# ophub 机顶盒 Board 列表

数据来源: [ophub/amlogic-s9xxx-armbian model_database.conf](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/build-armbian/armbian-files/common-files/etc/model_database.conf)

> 本文件由 `scripts/update-boards-docs.py` 根据 [data/boards.json](../data/boards.json) 自动生成，请勿手工编辑。

> Board 名用于 `build-ophub-armbian.yml` 的 `amlogic_soc` 参数，多个用 `_` 分隔。
>
> 还支持批量写法：`all` / `amlogic` / `rockchip` / `allwinner` / `first<N>` / `last<N>` / `range<N>_<M>` / `<platform><N>` / `<platform><N>_<M>`，
> 如 `first50`、`range50_100`、`amlogic50`、`rockchip50_100`。批量写法只包含 `BUILD=yes` 的 board。

### 可用内核版本

每个 board 的默认内核标签见各表中的「内核标签」列。`stable` 系列当前包含以下版本（2026-10-31）：

| 内核版本 | 最新补丁 | 说明 |
|---------|---------|------|
| `6.12.y` | 6.12.114 | LTS 长期支持（推荐） |
| `6.18.y` | 6.18.59 | 最新版 |
| `6.6.y` | 6.6.160 | LTS 长期支持 |
| `6.1.y` | 6.1.190 | LTS 长期支持 |
| `5.15.y` | 5.15.223 | 旧设备 |
| `5.10.y` | 5.10.272 | 旧设备 |

> 多个版本用 `_` 分隔，如 `6.6.y_6.12.y`，会为每个版本各生成一套镜像。
>
> **注意**：每个 board 的可选内核由表中的「内核标签」决定，并非所有 board 都能选全部版本：
>
> | 内核标签 | 含义 |
> |---------|------|
> | `stable/all` | 全部 stable 内核（上表全部版本） |
> | `stable/6.18.y` | 仅 6.18.y（多数 Rockchip/Allwinner 及部分 Amlogic 盒子） |
> | `stable/6.12.y` | 仅 6.12.y |
> | `rk3588/all` | rk3588 系列专用 BSP 内核（kernel_rk3588） |
> | `rk35xx/all` | rk3328/rk3399/rk3528/rk3566/rk3568 专用 BSP 内核（kernel_rk35xx） |
> | `rk35xx/6.1.y` | 上述 rk35xx 设备仅 6.1.y |
>
> BSP 内核当前最新：`6.12.69` / `6.1.174` / `5.10.160`。
>
> 本仓库 workflow 的 `armbian_kernel` 下拉框目前提供 `stable` / `6.12.y` / `6.18.y` / `6.6.y` / `6.1.y` / `5.15.y`；`5.10.y` 需直接调用上游 ophub action。

---

## Amlogic

### a311d

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `a311d` | Khadas-VIM3 | `stable/all` |
| `a311d-oes` | WXY-OES | `stable/all` |

### s922x

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `s922x` | GT-King-Pro, X88-King | `stable/all` |
| `s922x-ct2000` | Ali-CT2000 | `stable/all` |
| `s922x-gtking` | GT-King | `stable/all` |
| `s922x-gtkingpro-h` | GT-King-Pro-H | `stable/all` |
| `s922x-odroid-n2` | Hardkernel-ODroid-N2 | `stable/all` |
| `s922x-oes-plus` | WXY-OES-Plus | `stable/all` |
| `s922x-reva` | GT-King-Pro-Rev_A | `stable/all` |
| `s922x-ugoos-am6` | UGOOS-AM6-Plus | `stable/all` |

### s912

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `s912` | Octopus-Planet, OneCloudPro-V1.1, Tanix-TX9S | `stable/all` |
| `s912-h96pro-plus` | H96-Pro-Plus, TX92, Z6-Plus | `stable/all` |
| `s912-m8s-pro` | MECOOL-M8S-Pro-L, TX3-Mini | `stable/all` |
| `s912-nexbox-a1` | Nexbox-A1, A95X | `stable/all` |
| `s912-nexbox-a2` | Nexbox-A95X-A2 | `stable/all` |
| `s912-onecloudpro` | OneCloudPro-V1.2 | `stable/all` |
| `s912-onecloudpro-2` | OneCloudPro-V1.2-Flash-NewOS | `stable/all` |
| `s912-phicomm-t1` | Phicomm-T1 | `stable/all` |
| `s912-t95z-plus` | T95Z-Plus | `stable/all` |
| `s912-tx8-max` | Tanix-TX8-MAX | `stable/all` |
| `s912-tx9-pro-2g` | TX9-Pro(2G_16G_100Mb) | `stable/all` |
| `s912-tx9-pro-3g` | TX9-Pro(3G_32G_1Gb) | `stable/all` |
| `s912-x92` | Vontar-X92 | `stable/all` |
| `s912-zyxq-fake` | Octopus-Planet(FAKE) | `stable/all` |

### s905x3

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `s905x3` | X96-Max+_100Mb | `stable/all` |
| `s905x3-2101` | X96-Max+_2101 | `stable/all` |
| `s905x3-a100` | X96-Max+_A100 | `stable/all` |
| `s905x3-a95xf3` | A95XF3-Air-100Mb | `stable/all` |
| `s905x3-a95xf3-gb` | A95XF3-Air-1Gb | `stable/all` |
| `s905x3-b` | Tencent-Aurora-3Pro | `stable/all` |
| `s905x3-h96max` | H96-Max-X3, Infinity-B32 | `stable/all` |
| `s905x3-h96max-oc` | H96-Max-X3(OverClock), B32 | `stable/all` |
| `s905x3-hk1` | HK1-Box, Vontar-X3 | `stable/all` |
| `s905x3-hk1-oc` | HK1-Box(OverClock) | `stable/all` |
| `s905x3-ip1001m` | X96-Max+(IP1001M) | `stable/all` |
| `s905x3-q1` | X96-Max+Q1 | `stable/all` |
| `s905x3-q2` | X96-Max+Q2, X96-Air-Q1000 | `stable/all` |
| `s905x3-tox1` | TOX1 | `stable/all` |
| `s905x3-tx3` | TX3-1Gb | `stable/all` |
| `s905x3-tx3-bz` | TX3-100Mb | `stable/all` |
| `s905x3-tx3-bz-oc` | TX3-100Mb(OverClock) | `stable/all` |
| `s905x3-tx3-oc` | TX3-1Gb(OverClock) | `stable/all` |
| `s905x3-ugoosx3` | Ugoos-X3 | `stable/all` |
| `s905x3-ugoosx3-oc` | Ugoos-X3(OverClock) | `stable/all` |
| `s905x3-whale` | Whale | `stable/all` |
| `s905x3-x88-pro-x3` | X88-Pro-X3, X99-Max+, Transpeed-X3+ | `stable/all` |
| `s905x3-x96air` | X96-Air-100Mb, X96-Max+100W | `stable/all` |
| `s905x3-x96air-gb` | X96-Air-1Gb | `stable/all` |
| `s905x3-x96max` | X96-Max+_1GB | `stable/all` |
| `s905x3-x96max-oc` | X96-Max+(OverClock) | `stable/all` |

### s905x2

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `s905x2` | X96-Max-4GB, Tx5-Max | `stable/all` |
| `s905x2-b860h-v5` | ZTE-B860H-V5 | `stable/all` |
| `s905x2-hg680fj` | HG680-FJ | `stable/all` |
| `s905x2-km3` | MECOOL-KM3-4G | `stable/all` |
| `s905x2-w103d` | ZTE-W103D | `stable/6.18.y` |
| `s905x2-x96max-2g` | X96-Max-2GB, A95X-F2 | `stable/all` |

### s905x

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `s905x` | HG680P, BTV-9, BTV-10(BX) | `stable/all` |
| `s905x-b860h` | B860H | `stable/all` |
| `s905x-nexbox-a95x` | Nexbox-a95x | `stable/all` |
| `s905x-t95` | T95, XiaoMI-3S, X96, BTV9 | `stable/all` |
| `s905x-tbee` | TBee | `stable/all` |
| `s905x-tx9` | TX9 | `stable/all` |

### s905w

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `s905w` | TX3-Mini, MeCool-m8s-pro-W | `stable/all` |
| `s905w-w95` | W95 | `stable/all` |
| `s905w-x96-mini` | X96-Mini | `stable/all` |
| `s905w-x96w` | X96W, FunTV, MXQ-Pro-4K | `stable/all` |

### s905d

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `s905d` | Phicomm-N1 | `stable/all` |
| `s905d-ki-pro` | MECOOL-KI-Pro | `stable/all` |
| `s905d-n1-thresh` | Phicomm-N1(DMA-thresh) | `stable/all` |
| `s905d-sml5442tw` | SML-5442TW | `stable/all` |

### s905

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `s905` | Sunvell-T95M, SumaVision-Q5 | `stable/all` |
| `s905-beelink-mini` | Beelink-Mini-MX-2G | `stable/all` |
| `s905-mxqpro-plus` | MXQ-Pro+ | `stable/all` |

### s905d3

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `s905d3-khadas-vim3l` | Khadas-VIM3L | `stable/all` |

### s905l / s905l2 / s905l3 / s905l3a / s905l3b / s905lb / s905mb

| Board | SOC | 设备 | 内核标签 |
|-------|-----|------|---------|
| `s905l` | s905l | UNT402A, M201-S, MiBox-4C, IP108H, B860AV2.1 | `stable/6.18.y` |
| `s905l-aurora-1s` | s905l | Tencent-Aurora-1s | `stable/all` |
| `s905l-b860av21u` | s905l | ZXV10-B860AV2.1U, HM201 | `stable/all` |
| `s905l-mg101` | s905l | MG101, Mibox-4, E900V21C, XiaoMI-4C | `stable/all` |
| `s905l2` | s905l2 | MGV2000, MGV3000, M301A, CM201-1, IP108H | `stable/6.18.y` |
| `s905l2-e900v21e` | s905l2 | E900v21E, MGV2000-K, e900v21d | `stable/6.18.y` |
| `s905l2-wojia` | s905l2 | Wojia-TV-IPBS9505 | `stable/6.18.y` |
| `s905l3` | s905l3 | CM311-1, HG680-LC, M401A, UNT402A, CM201-1-6-YS | `stable/6.18.y` |
| `s905l3-cm211` | s905l3 | CM211-1, M411A, B860AV3.2M, B860AV2.1U, M301A | `stable/6.18.y` |
| `s905l3-unt400g1` | s905l3 | UNT400G1, E900V22D-2, UNT400G, IP108H | `stable/6.18.y` |
| `s905l3-unt402a` | s905l3 | UNT402A, UNT400G | `stable/6.18.y` |
| `s905l3a` | s905l3a | E900V22C-D, CM311-1a-CH, IP112H, B863AV3.1 | `stable/all` |
| `s905l3a-cm311` | s905l3a | CM311-1a-YST | `stable/all` |
| `s905l3a-m401a` | s905l3a | M401A, UNT403A, B863AV3.2-M | `stable/all` |
| `s905l3b` | s905l3b | M302A, M304A, CM201-1, CM211-1, CM311-1 | `stable/6.18.y` |
| `s905l3b-e900v21d` | s905l3b | E900V21D, B860AV2.1-A | `stable/6.18.y` |
| `s905l3b-e900v22d` | s905l3b | E900V22D, TY1608 | `stable/6.18.y` |
| `s905l3b-e900v22e` | s905l3b | E900V21E, E900V22E, MGV2000/CW, M411A | `stable/6.18.y` |
| `s905l3b-ip103h` | s905l3b | IP103H, TY1608, BV310, B860AV-2.1M | `stable/6.18.y` |
| `s905l3b-m302a` | s905l3b | ZXV10-B860AV2.1 | `stable/6.18.y` |
| `s905l3b-rg020et-ca` | s905l3b | RG020ET-CA | `stable/6.18.y` |
| `s905l3b-unt403a` | s905l3b | UNT403A | `stable/6.18.y` |
| `s905lb-ipbs9505` | s905lb | IPBS9505 | `stable/6.18.y` |
| `s905lb-q96-mini` | s905lb | Q96-mini | `stable/all` |
| `s905lb-r3300l` | s905lb | BesTV-R3300L, SumaVision-Q7, MG101 | `stable/all` |
| `s905mb` | s905mb | S65 | `stable/all` |

---

## Rockchip

### rk3588 / rk3588s

| Board | SOC | 设备 | 内核标签 |
|-------|-----|------|---------|
| `bdy-g98` | rk3588 | BDY-G98 | `stable/6.18.y` |
| `boca-tcn100` | rk3588s | Boca-tcn100 | `rk3588/all` |
| `boca-tcn200` | rk3588s | Boca-tcn200 | `rk3588/all` |
| `cm3588-nas` | rk3588 | FriendlyElec-CM3588-NAS | `rk3588/all` |
| `dc-a588` | rk3588 | DC-A588 | `rk3588/all` |
| `easepi-r2` | rk3588 | LinkEase-EasePi-R2 | `stable/6.18.y` |
| `elfboard-elf2` | rk3588 | Forlinx-ELF2 | `stable/6.18.y` |
| `firefly-itx-3588j` | rk3588 | Firefly-ITX-3588J | `stable/6.18.y` |
| `h88k` | rk3588 | HLink-H88K | `stable/6.18.y` |
| `h88k-v3` | rk3588 | HLink-H88K-V31 | `stable/6.18.y` |
| `indiedroid-nova` | rk3588s | Indiedroid-Nova | `stable/6.18.y` |
| `ipc-r` | rk3588 | IPC-R | `rk3588/all` |
| `lubancat-4` | rk3588s | LubanCat-4 | `stable/6.18.y` |
| `lubancat-5` | rk3588 | LubanCat-5 | `stable/6.18.y` |
| `lz-d3588` | rk3588 | LZ-D3588 | `stable/6.18.y` |
| `nanopc-t6` | rk3588 | NanoPC-T6 | `rk3588/all` |
| `orangepi-5-plus` | rk3588 | Orange-Pi-5-Plus | `stable/6.18.y` |
| `orangepi-5-pro` | rk3588s | Orange-Pi-5-Pro | `stable/6.18.y` |
| `orangepi-5-ultra` | rk3588 | Orange-Pi-5-Ultra | `stable/6.18.y` |
| `orangepi-5b` | rk3588s | Orange-Pi-5B | `stable/6.18.y` |
| `quarkpi-ca2` | rk3588s | ALIENTEK-QuarkPi-CA2 | `stable/6.18.y` |
| `rock-5-itx` | rk3588 | Rock-5-ITX | `stable/6.18.y` |
| `rock5b` | rk3588 | Rock5B | `rk3588/all` |
| `rock5c` | rk3588s | Rock5C | `rk3588/all` |
| `seewo-sv50` | rk3588 | Seewo-SV50 | `stable/6.18.y` |
| `smart-am60` | rk3588 | Smart-Am60 | `rk3588/all` |
| `youyeetoo-r1-v3` | rk3588s | Youyeetoo-R1-V3 | `stable/6.18.y` |
| `youyeetoo-yy3588` | rk3588 | Youyeetoo-YY3588 | `stable/6.18.y` |

### rk3576

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `lckfb-tspi-3m` | LCKFB-Taishan-Pi-3M | `stable/6.18.y` |
| `lubancat-3` | LubanCat-3 | `stable/6.18.y` |
| `nanopi-m5` | NanoPi-m5 | `stable/6.18.y` |
| `recomputer-rk3576-devkit` | reComputer-RK3576-DevKit | `stable/6.18.y` |

### rk3568

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `alark35-3500` | Alark35-3500 | `stable/6.18.y` |
| `anas3035` | MMBox-Anas3035 | `stable/6.18.y` |
| `bdkj-bd-one` | BDKJ-One | `stable/6.18.y` |
| `bdy-g18-pro` | BDY-G18-Pro | `stable/6.18.y` |
| `dg-nas-lite` | DG-Nas-Lite | `stable/6.18.y` |
| `dg-tn3568` | DG-TN3568 | `stable/6.18.y` |
| `e25` | E25 | `rk35xx/all` |
| `easepi-a2` | LinkEase-EasePi-A2 | `stable/6.18.y` |
| `gzpeite-p01` | Gzpeite-P01 | `rk35xx/all` |
| `h66k` | HLink-H66K | `stable/6.18.y` |
| `h68k` | HLink-H68K | `stable/6.18.y` |
| `h69k` | HLink-H69K | `stable/6.18.y` |
| `houzzkit-f1` | Houzzkit-F1 | `stable/6.18.y` |
| `lubancat-2` | LubanCat-2 | `stable/6.18.y` |
| `lyt-t68m` | Lyt-t68m | `stable/6.18.y` |
| `lz-d3568` | LZ-D3568 | `stable/6.18.y` |
| `lz-k3568` | LZ-K3568 | `stable/6.18.y` |
| `mrkaio-m68s` | Mrkaio-m68s | `stable/6.18.y` |
| `nanopi-r5c` | NanoPi-R5C | `stable/6.18.y` |
| `nanopi-r5s` | NanoPi-R5S | `stable/6.18.y` |
| `nsy-g16-plus` | NSY-G16-Plus | `stable/6.18.y` |
| `nsy-g68-plus` | NSY-G68-Plus | `stable/6.18.y` |
| `photonicat` | photonicat | `stable/6.18.y` |
| `r66s` | R66S | `rk35xx/all` |
| `r68s` | R68S | `rk35xx/all` |
| `roceos-k40pro` | Roceos-K40Pro | `stable/6.18.y` |
| `rock-3a` | Rock-3A | `stable/6.18.y` |
| `rock-3b` | Rock-3B | `stable/6.18.y` |
| `ruisen-box` | Ruisen-box | `rk35xx/all` |
| `seewo-sv21` | Seewo-sv21 | `stable/6.18.y` |
| `station-p2` | Station-P2 | `stable/6.18.y` |
| `swan1-w28` | Swan1-w28 | `rk35xx/all` |
| `wocyber-a3` | Wocyber-A3 | `stable/6.18.y` |
| `youyeetoo-yy3568` | Youyeetoo-YY3568 | `stable/6.18.y` |
| `ztl-a568` | DC_A568(ztl-a568) | `stable/6.18.y` |

### rk3566

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `jp-tvbox` | JP-TvBox | `rk35xx/all` |
| `kickpi-k11c-v12` | KICKPI-K11C-V12 | `rk35xx/all` |
| `lckfb-tspi` | LCKFB-Taishan-Pi | `stable/6.18.y` |
| `lubancat-1` | LubanCat-1 | `stable/6.18.y` |
| `md1000` | Inspur-MD1000 | `stable/6.18.y` |
| `orangepi-3b` | Orange-Pi-3B | `rk35xx/all` |
| `panther-x2` | Panther-X2 | `stable/6.18.y` |
| `rock-3c` | Rock-3C | `stable/6.18.y` |
| `station-m2` | Station-M2 | `rk35xx/all` |
| `torder-r10d` | Torder-R10D | `rk35xx/6.1.y` |
| `wxy-oect` | WXY-OEC-turbo-4g(Original-Edition) | `rk35xx/all` |
| `wxy-oect-mod` | WXY-OEC-turbo-4g(Replaced-Chip-eMMC) | `rk35xx/all` |
| `x88pro20` | X88Pro20 | `rk35xx/all` |

### rk3528

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `cd1000` | Inspur-CD1000-Cloud-PC | `rk35xx/all` |
| `e20c` | Radxa-E20C | `rk35xx/all` |
| `h28k` | HLink-H28K | `rk35xx/all` |
| `h96-max-m2` | H96-Max-M2 | `rk35xx/all` |
| `hk1-rbox-k8s` | HK1-Rbox-K8S | `stable/6.18.y` |
| `ht2` | HT2 | `stable/6.18.y` |
| `mytv-net1` | P52(VNPT-MyTV-Net-1) | `rk35xx/6.1.y` |
| `x88pro13` | P51(X88-Pro-13) | `rk35xx/all` |
| `xingyicloud` | XingYiCloud | `stable/6.18.y` |

### rk3399

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `aio-3399b` | AIO-3399b | `stable/6.18.y` |
| `aio-3399c` | AIO-3399C | `stable/6.18.y` |
| `aio-3399c-ai` | AIO-3399C(AI) | `stable/6.18.y` |
| `crrc` | CRRC | `stable/6.18.y` |
| `dg3399` | DG-3399 | `stable/6.18.y` |
| `dlfr100` | Dilusense-DLFR100 | `stable/6.18.y` |
| `eaidk-610` | EAIDK-610 | `rk35xx/all` |
| `emb3531` | EMB3531 | `stable/6.18.y` |
| `fine3399` | Fine3399 | `stable/6.18.y` |
| `firefly-jd4` | Firefly-Core-3399-JD4 | `stable/6.18.y` |
| `firefly-rk3399` | Firefly-RK3399 | `stable/6.18.y` |
| `fmx1-pro` | Fmx1-Pro | `stable/6.18.y` |
| `fmx1-pro-b` | Fmx1-Pro-B | `stable/6.18.y` |
| `gea-6319` | GEA-6319 | `stable/6.18.y` |
| `h339pc` | H339PC | `stable/6.18.y` |
| `hs530r` | Hisense-hs530r | `stable/6.18.y` |
| `hugsun-x99` | Hugsun-X99 | `stable/6.18.y` |
| `king3399` | King3399 | `stable/6.18.y` |
| `kylin3399` | Kylin3399 | `stable/6.18.y` |
| `leez` | Leez-P710 | `stable/6.18.y` |
| `lx-r3s` | LX-R3S | `stable/6.18.y` |
| `lzk4` | LZK4 | `stable/6.18.y` |
| `nanopc-t4` | NanoPC-T4 | `stable/6.18.y` |
| `nanopi-som` | NanoPi-SOM-RK3399 | `stable/6.18.y` |
| `smart-am40` | SMART-AM40 | `stable/6.12.y` |
| `sv-33a6x` | Sv-33a6x | `stable/6.18.y` |
| `sv-33a6x-vpu` | Sv-33a6x(VPU) | `stable/6.18.y` |
| `sw799` | SW799 | `stable/6.18.y` |
| `sz3390` | SZ3390 | `stable/6.18.y` |
| `taram` | TaraM | `stable/6.18.y` |
| `tb-ls3399` | Tb-ls3399 | `stable/6.18.y` |
| `tn3399` | TN3399 | `stable/6.18.y` |
| `tpm312` | Tpm312 | `stable/6.18.y` |
| `tps781` | TPS781 | `stable/6.18.y` |
| `tvi3315a` | tvi3315a | `stable/6.18.y` |
| `xiaobao` | xiaobao | `stable/6.18.y` |
| `yskj` | YSKJ | `stable/6.18.y` |
| `zcube1-max` | ZCube1-Max | `rk35xx/all` |
| `zk-r39a` | ZK-rk39a | `stable/6.18.y` |
| `zysj` | ZYSJ | `stable/6.18.y` |

### rk3328

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `beikeyun` | BeikeYun | `stable/6.18.y` |
| `chainedbox` | Chainedbox-L1-Pro | `stable/6.18.y` |
| `renegade-rk3328` | Renegade-RK3328, Firefly-RK3328 | `rk35xx/all` |
| `station-m1` | Station-M1, Bqeel-MVR9 | `stable/6.18.y` |

### rk3318

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `rk3318-box` | rk3318-box | `stable/6.18.y` |

---

## Allwinner

### h6

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `tanix-tx6` | Tanix-TX6, TX6-H, T95-max | `stable/6.18.y` |
| `tqc-a01` | TaiqiCat(TQC)-A01 | `stable/6.18.y` |
| `vplus` | Vplus-Cloud | `stable/6.18.y` |

### h618

| Board | 设备 | 内核标签 |
|-------|------|---------|
| `bt-1000m` | H618-BT-1000M | `stable/6.18.y` |
| `bt-100m` | H618-BT-100M | `stable/6.18.y` |
| `h618-ai-douhe` | H618-AI-Douhe | `stable/6.18.y` |
| `h618-devboard` | H618-DevBoard, CJDS | `stable/6.18.y` |
| `orangepi-zero3` | OrangePi-Zero3 | `stable/6.18.y` |
| `painet-p3` | PaiNet-P3 | `stable/6.18.y` |
| `painet-p5` | PaiNet-P5 | `stable/6.18.y` |
| `vontar-h618` | Vontar-H618 | `stable/6.18.y` |
| `x98h` | X98H | `stable/6.18.y` |
| `x98h-100mb` | X98H-100mb | `stable/6.18.y` |
