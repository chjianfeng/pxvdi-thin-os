#!/usr/bin/env python3
"""Update data/boards.json from upstream and render docs/*-boards.md from it.

Usage:
    python3 scripts/update-boards-docs.py update [--skip-kernel]
    python3 scripts/update-boards-docs.py render
    python3 scripts/update-boards-docs.py check

The JSON file is the single source of truth for this repo. Never edit the
Markdown files by hand; run `render` after changing the JSON.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
JSON_PATH = ROOT / "data" / "boards.json"
OPHUB_DOC = ROOT / "docs" / "ophub-boards.md"
ARMBIAN_DOC = ROOT / "docs" / "armbian-boards.md"

OPHUB_REPO = "ophub/amlogic-s9xxx-armbian"
OPHUB_CONF_URL = (
    "https://raw.githubusercontent.com/ophub/amlogic-s9xxx-armbian/main/"
    "build-armbian/armbian-files/common-files/etc/model_database.conf"
)
OPHUB_CONF_PATH = (
    "build-armbian/armbian-files/common-files/etc/model_database.conf"
)
ARMBIAN_REPO = "armbian/build"
ARMBIAN_URL = "https://github.com/armbian/build.git"

CATEGORY_ORDER = ["conf", "csc", "tvb", "wip", "eos"]
CATEGORY_TITLES = {
    "conf": "官方支持 (.conf)",
    "csc": "社区支持 (.csc)",
    "tvb": "TV Box (.tvb)",
    "wip": "开发中 (.wip)",
    "eos": "已停止维护 (.eos)",
}

OPHUB_SOC_ORDER = {
    "amlogic": ["a311d", "s922x", "s912", "s905x3", "s905x2", "s905x",
                "s905w", "s905d", "s905", "s905d3"],
    "rockchip": ["rk3588s", "rk3588", "rk3576", "rk3568", "rk3566",
                 "rk3528", "rk3399", "rk3328", "rk3318"],
    "allwinner": ["h6", "h618"],
}

STABLE_FAMILY_ORDER = ["6.12.y", "6.18.y", "6.6.y", "6.1.y", "5.15.y", "5.10.y"]
STABLE_FAMILY_DESC = {
    "6.12.y": "LTS 长期支持（推荐）",
    "6.18.y": "最新版",
    "6.6.y": "LTS 长期支持",
    "6.1.y": "LTS 长期支持",
    "5.15.y": "旧设备",
    "5.10.y": "旧设备",
}

TAG_MEANINGS = [
    ("stable/all", "全部 stable 内核（上表全部版本）"),
    ("stable/6.18.y", "仅 6.18.y（多数 Rockchip/Allwinner 及部分 Amlogic 盒子）"),
    ("stable/6.12.y", "仅 6.12.y"),
    ("rk3588/all", "rk3588 系列专用 BSP 内核（kernel_rk3588）"),
    ("rk35xx/all", "rk3328/rk3399/rk3528/rk3566/rk3568 专用 BSP 内核（kernel_rk35xx）"),
    ("rk35xx/6.1.y", "上述 rk35xx 设备仅 6.1.y"),
]

GENERATED_NOTE = (
    "> 本文件由 `scripts/update-boards-docs.py` 根据 "
    "[data/boards.json](../data/boards.json) 自动生成，请勿手工编辑。"
)


# --------------------------------------------------------------------------
# fetching / parsing
# --------------------------------------------------------------------------

def http_get(url: str, timeout: int = 60) -> str:
    req = urllib.request.Request(
        url, headers={"User-Agent": "pxvdi-thin-os-board-updater"}
    )
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return resp.read().decode("utf-8")


def parse_ophub(text: str) -> list[dict]:
    boards = []
    for line in text.splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        fields = [f.strip() for f in line.split(":")]
        if len(fields) < 15:
            continue
        boards.append({
            "id": fields[0],
            "board": fields[13],
            "model": fields[1],
            "soc": fields[2],
            "platform": fields[9],
            "family": fields[10],
            "kernel_tags": fields[8],
            "build": fields[14].lower() == "yes",
        })
    boards.sort(key=lambda b: b["board"])
    return boards


def fetch_kernel_versions() -> dict:
    """Return the latest patch per family for stable/rk3588/rk35xx."""
    result = {}
    for tag in ("stable", "rk3588", "rk35xx"):
        url = f"https://github.com/ophub/kernel/releases/expanded_assets/kernel_{tag}"
        html = http_get(url)
        versions = set(re.findall(
            rf"kernel_{tag}/(\d+\.\d+\.\d+)\.tar\.gz", html
        ))
        families = {}
        for version in versions:
            family = version.rsplit(".", 1)[0] + ".y"
            if family not in families or _vkey(version) > _vkey(families[family]):
                families[family] = version
        result[tag] = dict(sorted(
            families.items(), key=lambda kv: _vkey(kv[1])))
    return result


def _vkey(version: str) -> tuple:
    return tuple(int(x) for x in version.split("."))


def clone_armbian(ref: str) -> tuple[str, str, str]:
    """Sparse-clone armbian/build and return (boards_dir, commit)."""
    tmp = tempfile.mkdtemp(prefix="armbian-build-")
    try:
        _run(["git", "clone", "--depth", "1", "--filter=blob:none", "--sparse",
              "--branch", ref, ARMBIAN_URL, tmp])
        _run(["git", "-C", tmp, "sparse-checkout", "set", "config/boards"])
        commit = _run(["git", "-C", tmp, "rev-parse", "HEAD"]).strip()
        return str(Path(tmp) / "config" / "boards"), commit, tmp
    except Exception:
        shutil.rmtree(tmp, ignore_errors=True)
        raise


def _run(cmd: list[str]) -> str:
    proc = subprocess.run(cmd, capture_output=True, text=True,
                          env={**os.environ, "GIT_TERMINAL_PROMPT": "0"})
    if proc.returncode != 0:
        raise RuntimeError(f"{' '.join(cmd)} failed:\n{proc.stderr.strip()}")
    return proc.stdout


def parse_armbian(boards_dir: Path) -> tuple[list[dict], list[dict]]:
    priority = {ext: i for i, ext in enumerate(CATEGORY_ORDER)}
    found: dict[str, dict] = {}
    duplicates = []
    for path in sorted(boards_dir.iterdir()):
        if path.suffix.lstrip(".") not in priority:
            continue
        category = path.suffix.lstrip(".")
        board = path.stem
        text = path.read_text(encoding="utf-8", errors="replace")
        match = re.search(
            r'^\s*(?:declare\s+-g\s+)?KERNEL_TARGET\s*=\s*"?([^"\n]*)"?',
            text, re.M,
        )
        target = match.group(1) if match else ""
        branches = [x.strip() for x in target.split(",") if x.strip()]
        name_match = re.search(r'^\s*(?:declare\s+-g\s+)?BOARD_NAME\s*=\s*"([^"]*)"', text, re.M)
        entry = {
            "board": board,
            "name": name_match.group(1) if name_match else "",
            "category": category,
            "kernel_target": branches,
        }
        if board in found:
            duplicates.append({
                "board": board,
                "categories": [found[board]["category"], category],
            })
            if priority[category] >= priority[found[board]["category"]]:
                continue
        found[board] = entry
    boards = sorted(found.values(), key=lambda b: b["board"])
    duplicates.sort(key=lambda d: d["board"])
    return boards, duplicates


def build_model(previous: dict | None) -> dict:
    print("Fetching ophub model_database.conf ...")
    ophub_boards = parse_ophub(http_get(OPHUB_CONF_URL))
    if len(ophub_boards) < 200:
        raise RuntimeError(f"suspicious ophub board count: {len(ophub_boards)}")

    print("Fetching kernel releases ...")
    try:
        kernels = fetch_kernel_versions()
        if not all(kernels.get(k) for k in ("stable", "rk3588", "rk35xx")):
            raise RuntimeError("empty kernel version list")
    except Exception as exc:  # keep the previous snapshot rather than failing
        print(f"WARNING: kernel fetch failed ({exc}); keeping previous values",
              file=sys.stderr)
        kernels = (previous or {}).get("ophub", {}).get("kernels", {})

    print("Cloning armbian/build (sparse: config/boards) ...")
    boards_dir, commit, tmp = clone_armbian("main")
    try:
        armbian_boards, duplicates = parse_armbian(Path(boards_dir))
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    if len(armbian_boards) < 400:
        raise RuntimeError(f"suspicious armbian board count: {len(armbian_boards)}")

    if previous:
        old = len(previous.get("ophub", {}).get("boards", []))
        if old and len(ophub_boards) < old * 0.8:
            raise RuntimeError(
                f"ophub board count dropped from {old} to {len(ophub_boards)}"
            )
        old = len(previous.get("armbian", {}).get("boards", []))
        if old and len(armbian_boards) < old * 0.8:
            raise RuntimeError(
                f"armbian board count dropped from {old} to {len(armbian_boards)}"
            )

    return {
        "schema_version": 1,
        "generated_at": datetime.now(timezone.utc).replace(
            microsecond=0).isoformat().replace("+00:00", "Z"),
        "sources": {
            "ophub": {
                "repo": OPHUB_REPO,
                "path": OPHUB_CONF_PATH,
                "ref": "main",
                "url": OPHUB_CONF_URL,
            },
            "armbian": {
                "repo": ARMBIAN_REPO,
                "ref": "main",
                "commit": commit,
            },
        },
        "ophub": {"boards": ophub_boards, "kernels": kernels},
        "armbian": {"boards": armbian_boards, "duplicates": duplicates},
    }


# --------------------------------------------------------------------------
# rendering
# --------------------------------------------------------------------------

def _fmt_device(model: str) -> str:
    model = model.replace("[IDL],", "")
    return ", ".join(x.strip() for x in model.split(","))


def _fmt_branches(branches: list[str]) -> str:
    return ", ".join(f"`{b}`" for b in branches) if branches else "-"


def _ophub_table(boards: list[dict], socs: list[str], with_soc: bool,
                 title: str) -> str:
    selected = [b for b in boards if b["soc"] in socs]
    selected.sort(key=lambda b: b["board"])
    out = [title, ""]
    if with_soc:
        out += ["| Board | SOC | 设备 | 内核标签 |",
                "|-------|-----|------|---------|"]
        for b in selected:
            out.append(
                f"| `{b['board']}` | {b['soc']} | "
                f"{_fmt_device(b['model'])} | `{b['kernel_tags']}` |"
            )
    else:
        out += ["| Board | 设备 | 内核标签 |", "|-------|------|---------|"]
        for b in selected:
            out.append(
                f"| `{b['board']}` | {_fmt_device(b['model'])} | "
                f"`{b['kernel_tags']}` |"
            )
    return "\n".join(out)


def render_ophub(data: dict) -> str:
    ophub = data["ophub"]
    boards = ophub["boards"]
    kernels = ophub.get("kernels", {})
    generated = data.get("generated_at", "")[:10]
    stable = kernels.get("stable", {})
    bsp = {}
    for tag in ("rk3588", "rk35xx"):
        for family, version in kernels.get(tag, {}).items():
            if family not in bsp or _vkey(version) > _vkey(bsp[family]):
                bsp[family] = version

    parts = [
        "# ophub 机顶盒 Board 列表",
        "",
        f"数据来源: [ophub/amlogic-s9xxx-armbian "
        f"model_database.conf](https://github.com/{OPHUB_REPO}/blob/main/{OPHUB_CONF_PATH})",
        "",
        GENERATED_NOTE,
        "",
        "> Board 名用于 `build-ophub-armbian.yml` 的 `amlogic_soc` 参数，多个用 `_` 分隔。",
        ">",
        "> 还支持批量写法：`all` / `amlogic` / `rockchip` / `allwinner` / "
        "`first<N>` / `last<N>` / `range<N>_<M>` / `<platform><N>` / "
        "`<platform><N>_<M>`，",
        "> 如 `first50`、`range50_100`、`amlogic50`、`rockchip50_100`。"
        "批量写法只包含 `BUILD=yes` 的 board。",
        "",
        "### 可用内核版本",
        "",
        f"每个 board 的默认内核标签见各表中的「内核标签」列。"
        f"`stable` 系列当前包含以下版本（{generated}）：",
        "",
        "| 内核版本 | 最新补丁 | 说明 |",
        "|---------|---------|------|",
    ]
    families = [f for f in STABLE_FAMILY_ORDER if f in stable]
    families += sorted(f for f in stable if f not in STABLE_FAMILY_ORDER)
    for family in families:
        desc = STABLE_FAMILY_DESC.get(family, "稳定版")
        parts.append(f"| `{family}` | {stable[family]} | {desc} |")

    parts += [
        "",
        "> 多个版本用 `_` 分隔，如 `6.6.y_6.12.y`，会为每个版本各生成一套镜像。",
        ">",
        "> **注意**：每个 board 的可选内核由表中的「内核标签」决定，"
        "并非所有 board 都能选全部版本：",
        ">",
        "> | 内核标签 | 含义 |",
        "> |---------|------|",
    ]
    known_tags = {tag for tag, _ in TAG_MEANINGS}
    for tag, meaning in TAG_MEANINGS:
        parts.append(f"> | `{tag}` | {meaning} |")
    extra_tags = sorted({b["kernel_tags"] for b in boards} - known_tags)
    for tag in extra_tags:
        parts.append(f"> | `{tag}` | 上游定义的内核标签 |")

    if bsp:
        latest = " / ".join(
            f"`{v}`" for _, v in sorted(
                bsp.items(), key=lambda kv: _vkey(kv[1]), reverse=True)
        )
        parts += [">", f"> BSP 内核当前最新：{latest}。"]

    parts += [
        ">",
        "> 本仓库 workflow 的 `armbian_kernel` 下拉框目前提供 `stable` / "
        "`6.12.y` / `6.18.y` / `6.6.y` / `6.1.y` / `5.15.y`；"
        "`5.10.y` 需直接调用上游 ophub action。",
        "",
        "---",
        "",
        "## Amlogic",
        "",
    ]

    rendered_socs = set()

    def add(platform: str, socs: list[str], with_soc: bool = False,
            title: str | None = None) -> None:
        socs = [s for s in socs if any(
            b["platform"] == platform and b["soc"] == s for b in boards)]
        if not socs:
            return
        rendered_socs.update(socs)
        label = title or " / ".join(socs)
        parts.append(_ophub_table(boards, socs, with_soc, f"### {label}"))
        parts.append("")

    for soc in OPHUB_SOC_ORDER["amlogic"]:
        add("amlogic", [soc])
    family_socs = sorted({
        b["soc"] for b in boards
        if b["platform"] == "amlogic"
        and (b["soc"].startswith("s905l") or b["soc"] == "s905mb")
    })
    add("amlogic", family_socs, with_soc=True)
    leftovers = sorted({
        b["soc"] for b in boards
        if b["platform"] == "amlogic" and b["soc"] not in rendered_socs
    })
    for soc in leftovers:
        add("amlogic", [soc])

    parts += ["---", "", "## Rockchip", ""]
    add("rockchip", ["rk3588", "rk3588s"], with_soc=True,
        title="rk3588 / rk3588s")
    for soc in OPHUB_SOC_ORDER["rockchip"]:
        if soc not in ("rk3588", "rk3588s"):
            add("rockchip", [soc])
    leftovers = sorted({
        b["soc"] for b in boards
        if b["platform"] == "rockchip" and b["soc"] not in rendered_socs
    })
    for soc in leftovers:
        add("rockchip", [soc])

    parts += ["---", "", "## Allwinner", ""]
    for soc in OPHUB_SOC_ORDER["allwinner"]:
        add("allwinner", [soc])
    leftovers = sorted({
        b["soc"] for b in boards
        if b["platform"] == "allwinner" and b["soc"] not in rendered_socs
    })
    for soc in leftovers:
        add("allwinner", [soc])

    return "\n".join(parts).rstrip() + "\n"


def render_armbian(data: dict) -> str:
    armbian = data["armbian"]
    boards = armbian["boards"]
    duplicates = armbian.get("duplicates", [])
    generated = data.get("generated_at", "")[:10]
    total = len(boards)

    parts = [
        "# Armbian 支持的 Board 列表",
        "",
        f"数据来源: [armbian/build config/boards](https://github.com/"
        f"{ARMBIAN_REPO}/tree/main/config/boards)",
        "",
        GENERATED_NOTE,
        "",
        "> Board 名用于 `build-official-armbian.yml` 的 `board` 参数，"
        "内核分支用于 `branch` 参数。",
        ">",
        f"> 本表以 Armbian main 分支为准（{generated}），共 {total} 个 board，"
        "按 `.conf` / `.csc` / `.tvb` / `.wip` / `.eos` 分类。",
        ">",
        "> workflow 的 `branch` 下拉框目前只提供 `vendor` / `current` / `edge`；"
        "表中的 `legacy` / `bleedingedge` / `vendor-rt` / `vendor-edge` / `cloud`，"
        "以及少数 board 自定义的分支名（如 `sc8280xp`），为上游声明但当前 workflow 未开放。",
        "",
    ]

    for category in CATEGORY_ORDER:
        items = [b for b in boards if b["category"] == category]
        parts += [
            f"## {CATEGORY_TITLES[category]} ({len(items)} 个)",
            "",
            "| Board | 内核分支 |",
            "|-------|---------|",
        ]
        for b in items:
            parts.append(f"| `{b['board']}` | {_fmt_branches(b['kernel_target'])} |")
        parts.append("")

    for dup in duplicates:
        cats = " / ".join(f"`.{c}`" for c in dup["categories"])
        parts.append(
            f"> 注：上游 `{dup['board']}` 同时存在 {cats}，"
            "已按官方 `.conf` 列出一次。"
        )
        parts.append("")

    return "\n".join(parts).rstrip() + "\n"


def render_docs(data: dict) -> dict[Path, str]:
    return {
        OPHUB_DOC: render_ophub(data),
        ARMBIAN_DOC: render_armbian(data),
    }


# --------------------------------------------------------------------------
# commands
# --------------------------------------------------------------------------

def load_json() -> dict:
    if not JSON_PATH.exists():
        raise SystemExit(f"{JSON_PATH} not found; run `update` first")
    return json.loads(JSON_PATH.read_text(encoding="utf-8"))


def write_json(data: dict) -> None:
    JSON_PATH.parent.mkdir(parents=True, exist_ok=True)
    JSON_PATH.write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def _fingerprint(data: dict) -> str:
    """Content that matters for build/docs, ignoring timestamps and commit SHAs."""
    return json.dumps({
        "ophub_boards": data.get("ophub", {}).get("boards"),
        "kernels": data.get("ophub", {}).get("kernels"),
        "armbian_boards": data.get("armbian", {}).get("boards"),
        "armbian_duplicates": data.get("armbian", {}).get("duplicates"),
    }, sort_keys=True, ensure_ascii=False)


def cmd_update(args: argparse.Namespace) -> int:
    previous = load_json() if JSON_PATH.exists() else None
    if args.skip_kernel and previous:
        previous_kernels = previous.get("ophub", {}).get("kernels", {})
    else:
        previous_kernels = None
    data = build_model(previous)
    if args.skip_kernel and previous_kernels:
        data["ophub"]["kernels"] = previous_kernels

    if previous and not args.force and _fingerprint(previous) == _fingerprint(data):
        # Keep the existing snapshot (and its generated_at) untouched.
        for path, content in render_docs(previous).items():
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding="utf-8")
        print("no board/kernel changes; files left untouched")
        print(f"  ophub boards:   {len(previous['ophub']['boards'])}")
        print(f"  armbian boards: {len(previous['armbian']['boards'])}")
        return 0

    write_json(data)
    for path, content in render_docs(data).items():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
    print(f"wrote {JSON_PATH.relative_to(ROOT)}")
    print(f"  ophub boards:   {len(data['ophub']['boards'])}")
    print(f"  armbian boards: {len(data['armbian']['boards'])}")
    return 0


def cmd_render(_: argparse.Namespace) -> int:
    data = load_json()
    for path, content in render_docs(data).items():
        path.write_text(content, encoding="utf-8")
        print(f"wrote {path.relative_to(ROOT)}")
    return 0


def cmd_check(_: argparse.Namespace) -> int:
    data = load_json()
    failed = False
    for path, expected in render_docs(data).items():
        actual = path.read_text(encoding="utf-8") if path.exists() else ""
        if actual != expected:
            print(f"out of date: {path.relative_to(ROOT)}", file=sys.stderr)
            failed = True
    if failed:
        print("run: python3 scripts/update-boards-docs.py render", file=sys.stderr)
        return 1
    print("docs are up to date")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    p_update = sub.add_parser("update", help="fetch upstream and regenerate JSON + docs")
    p_update.add_argument("--skip-kernel", action="store_true",
                          help="keep kernel versions from the existing JSON")
    p_update.add_argument("--force", action="store_true",
                          help="rewrite files even when nothing changed")
    p_update.set_defaults(func=cmd_update)
    p_render = sub.add_parser("render", help="render docs from data/boards.json")
    p_render.set_defaults(func=cmd_render)
    p_check = sub.add_parser("check", help="fail if docs are not in sync with JSON")
    p_check.set_defaults(func=cmd_check)
    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
