# Armbian 支持的 Board 列表

数据来源: [armbian/build config/boards](https://github.com/armbian/build/tree/main/config/boards)

> 本文件由 `scripts/update-boards-docs.py` 根据 [data/boards.json](../data/boards.json) 自动生成，请勿手工编辑。

> Board 名用于 `build-official-armbian.yml` 的 `board` 参数，内核分支用于 `branch` 参数。
>
> 本表以 Armbian main 分支为准（2026-10-31），共 440 个 board，按 `.conf` / `.csc` / `.tvb` / `.wip` / `.eos` 分类。
>
> workflow 的 `branch` 下拉框目前只提供 `vendor` / `current` / `edge`；表中的 `legacy` / `bleedingedge` / `vendor-rt` / `vendor-edge` / `cloud`，以及少数 board 自定义的分支名（如 `sc8280xp`），为上游声明但当前 workflow 未开放。

## 官方支持 (.conf) (151 个)

| Board | 内核分支 |
|-------|---------|
| `aml-c400-plus` | `current`, `edge` |
| `anbernic-rg-ds` | `edge` |
| `anbernic-rg-vita-pro` | `edge` |
| `arduino-uno-q` | `edge` |
| `bananapi` | `current`, `edge`, `legacy` |
| `bananapicm4io` | `current`, `edge` |
| `bananapif3` | `legacy`, `current`, `edge` |
| `bananapim2s` | `current`, `edge` |
| `bananapim4berry` | `current`, `edge` |
| `bananapim4zero` | `current`, `edge` |
| `bananapim5` | `current`, `edge` |
| `bananapim5pro` | `edge`, `vendor` |
| `bananapim7` | `current`, `edge`, `vendor` |
| `bananapir2` | `current`, `edge` |
| `beaglebadge` | `vendor`, `vendor-rt` |
| `beaglebone-ai64` | `vendor`, `vendor-rt`, `edge` |
| `beagleplay` | `vendor`, `vendor-rt`, `edge` |
| `beagley-ai` | `vendor`, `vendor-rt`, `edge` |
| `bigtreetech-cb1` | `current`, `edge` |
| `bigtreetech-cb2` | `current`, `edge` |
| `boardcon-sbc3568` | `vendor` |
| `cix-acpi` | `current`, `edge` |
| `clearfogpro` | `current`, `edge` |
| `cubox-i` | `current`, `edge` |
| `dg-svr-865-tiny` | `current`, `edge` |
| `easepi-a2` | `current`, `edge`, `vendor` |
| `easepi-r2` | `current`, `edge`, `vendor` |
| `espressobin` | `current`, `edge` |
| `friendlyelec-rk3588` | `current`, `edge`, `vendor` |
| `gateway-dk` | `current` |
| `gateway-gz80x` | `current`, `edge` |
| `helios4` | `current`, `edge`, `legacy` |
| `helios64` | `current`, `edge` |
| `imb3588` | `vendor` |
| `inovato-quadra` | `current`, `edge` |
| `jethubj100` | `current`, `edge` |
| `jethubj200` | `current`, `edge` |
| `jethubj80` | `current`, `edge` |
| `k3picoitx` | `legacy`, `current` |
| `khadas-edge2` | `current`, `edge`, `vendor` |
| `khadas-vim1` | `current`, `edge` |
| `khadas-vim1s` | `legacy`, `edge` |
| `khadas-vim2` | `current`, `edge` |
| `khadas-vim3` | `current`, `edge` |
| `khadas-vim3l` | `current`, `edge` |
| `khadas-vim4` | `legacy`, `edge` |
| `kickpi-k3b` | `edge` |
| `lafrite` | `current`, `edge` |
| `lepotato` | `current`, `edge` |
| `lime-a64` | `current`, `edge`, `legacy` |
| `lubancat-5io` | `current`, `edge` |
| `luckfox-rk3308b-nova` | `current`, `edge` |
| `mba62xx-tqma62xx` | `vendor`, `edge` |
| `mba67xx-tqma67xx` | `vendor`, `edge` |
| `mba8mpxl` | `current`, `edge` |
| `mba8mpxl-ras314` | `current`, `edge` |
| `mba93xxca-tqma93xx` | `current`, `edge` |
| `mba93xxla-mini` | `current`, `edge` |
| `mekotronics-r58-4x4` | `edge`, `vendor` |
| `mekotronics-r58hd` | `vendor` |
| `mekotronics-r58s2` | `vendor` |
| `mksklipad50` | `current`, `edge` |
| `musebook` | `legacy`, `current` |
| `musepipro` | `legacy`, `current`, `edge` |
| `nanopct3plus` | `edge` |
| `nanopi-m5` | `current`, `edge`, `vendor` |
| `nanopi-r3s-lts` | `current`, `edge` |
| `nanopi-r4s` | `current`, `edge` |
| `nanopi-r76s` | `vendor`, `edge` |
| `nanopifire3` | `edge` |
| `nanopik1plus` | `current`, `edge`, `legacy` |
| `nanopik2-s905` | `current`, `edge` |
| `nanopim3` | `edge` |
| `nanopim4v2` | `current`, `edge` |
| `odroidc1` | `current` |
| `odroidc2` | `current`, `edge` |
| `odroidc4` | `current`, `edge` |
| `odroidhc4` | `current`, `edge` |
| `odroidm1` | `current`, `edge` |
| `odroidm2` | `current`, `edge` |
| `odroidn2` | `current`, `edge` |
| `odroidu2` | `current`, `edge` |
| `odroidxu4` | `current`, `edge` |
| `oneplus-kebab` | `current` |
| `orangepi3-lts` | `legacy`, `current`, `edge` |
| `orangepi4-lts` | `current`, `edge` |
| `orangepi5` | `current`, `edge`, `vendor` |
| `orangepi5-plus` | `current`, `edge`, `vendor` |
| `orangepione` | `current`, `edge`, `legacy` |
| `orangepipc2` | `current`, `edge`, `legacy` |
| `orangepizero3w` | `vendor` |
| `pocketbeagle2` | `vendor`, `vendor-rt` |
| `qidi-x6` | `current`, `edge` |
| `radxa-cm4-io` | `vendor` |
| `radxa-cm5-io` | `vendor`, `edge` |
| `radxa-dragon-q6a` | `current`, `edge` |
| `radxa-dragon-q8b` | `vendor`, `edge` |
| `radxa-e24c` | `edge`, `vendor` |
| `radxa-e25` | `current`, `edge`, `vendor` |
| `radxa-e52c` | `vendor`, `current`, `edge` |
| `radxa-e54c` | `vendor` |
| `radxa-nio-12l` | `edge` |
| `radxa-rock-4d` | `vendor`, `edge` |
| `radxa-zero` | `current`, `edge` |
| `radxa-zero3` | `vendor`, `current`, `edge` |
| `recomputer-rk3576-devkit` | `vendor`, `edge` |
| `recomputer-rk3588-devkit` | `vendor`, `edge` |
| `renegade` | `current`, `edge` |
| `rock-2a` | `vendor`, `current`, `edge` |
| `rock-2f` | `vendor`, `current`, `edge` |
| `rock-3a` | `current`, `edge`, `vendor` |
| `rock-5-itx` | `current`, `edge`, `vendor` |
| `rock-5a` | `current`, `edge`, `vendor` |
| `rock-5b` | `current`, `edge`, `vendor` |
| `rock-5b-plus` | `vendor`, `current`, `edge` |
| `rock-5c` | `vendor`, `current`, `edge` |
| `rock-5t` | `vendor`, `current`, `edge` |
| `rock-s0` | `current`, `edge` |
| `rockpi-4bplus` | `current`, `edge` |
| `rockpi-e` | `current`, `edge` |
| `rockpi-s` | `current`, `edge` |
| `rockpro64` | `current`, `edge` |
| `rpi4b` | `current`, `edge`, `legacy` |
| `sakurapi-rk3308b` | `current` |
| `sk-am62-lp` | `vendor`, `vendor-rt`, `vendor-edge`, `edge` |
| `sk-am62-sip` | `vendor`, `vendor-rt`, `vendor-edge`, `edge` |
| `sk-am62b` | `vendor`, `vendor-rt`, `vendor-edge`, `edge` |
| `sk-am62p` | `vendor`, `vendor-rt`, `vendor-edge`, `edge` |
| `sk-am64b` | `vendor`, `vendor-rt`, `vendor-edge`, `edge` |
| `sk-am68` | `vendor`, `vendor-rt`, `vendor-edge`, `edge` |
| `sk-am69` | `vendor`, `vendor-rt`, `vendor-edge`, `edge` |
| `sk-tda4vm` | `vendor`, `vendor-rt`, `vendor-edge`, `edge` |
| `sovol-zero` | `current`, `edge` |
| `sweet-potato` | `current`, `edge` |
| `tanix-tx6s` | `current`, `edge` |
| `tanix-tx6s-axp313` | `current`, `edge` |
| `thinkpad-x13s` | `sc8280xp` |
| `tinkerboard` | `current`, `edge` |
| `tmds62levm` | `vendor`, `vendor-rt`, `vendor-edge` |
| `tmds64evm` | `vendor`, `vendor-rt`, `vendor-edge`, `edge` |
| `tq-smarc2-tqma8mpxs` | `current`, `edge` |
| `turris-omnia` | `current`, `edge` |
| `udoo` | `current`, `edge` |
| `uefi-arm64` | `current`, `edge`, `legacy`, `cloud` |
| `uefi-arm64-dt` | `current`, `edge` |
| `uefi-loong64` | - |
| `uefi-x86` | `current`, `edge`, `legacy`, `cloud` |
| `verdin-imx8mm` | `current` |
| `xiaomi-elish` | `current`, `edge` |
| `youyeetoo-r1-v3` | `vendor`, `current`, `edge` |
| `youyeetoo-yy3588` | `vendor`, `current`, `edge` |

## 社区支持 (.csc) (240 个)

| Board | 内核分支 |
|-------|---------|
| `9tripod-x3568-v4` | `current`, `edge` |
| `agilex5-socdk` | `current` |
| `aml-a311d-cc` | `current`, `edge` |
| `aml-s905d3-cc` | `current`, `edge` |
| `anbernic-rg-rotate` | `edge` |
| `armsom-aim7-io` | `vendor` |
| `armsom-cm5-io` | `vendor`, `edge` |
| `armsom-cm5-rpi-cm4-io` | `vendor` |
| `armsom-cm7s-io` | `vendor` |
| `armsom-forge1` | `vendor` |
| `armsom-sige1` | `vendor` |
| `armsom-sige3` | `vendor` |
| `armsom-sige5` | `vendor`, `edge` |
| `armsom-sige7` | `current`, `edge`, `vendor` |
| `armsom-w3` | `vendor` |
| `avaota-a1` | `edge` |
| `ayn-odin2` | `current`, `edge` |
| `ayn-odin2mini` | `current`, `edge` |
| `ayn-odin2portal` | `current` |
| `ayn-odin3` | `edge` |
| `ayn-thor` | `current`, `edge` |
| `bananapim1plus` | `current`, `edge`, `legacy` |
| `bananapim2plus` | `current`, `edge`, `legacy` |
| `bananapim2pro` | `current`, `edge` |
| `bananapim2ultra` | `current`, `edge`, `legacy` |
| `bananapim2zero` | `current`, `edge`, `legacy` |
| `bananapim3` | `current`, `edge`, `legacy` |
| `bananapim4` | `current`, `edge` |
| `bananapim64` | `current`, `edge`, `legacy` |
| `bananapipro` | `current`, `edge`, `legacy` |
| `bananapir2pro` | `current`, `edge` |
| `bananapir3mini` | `current` |
| `bananapir4` | `current` |
| `bananapiw2` | `current`, `edge` |
| `bestv-r3300-l` | `current`, `edge` |
| `cainiao-cniot-core` | `current`, `edge` |
| `cherryba-m1` | `current`, `edge` |
| `clearfogbase` | `current`, `edge` |
| `clockworkpi-a06` | `current`, `edge` |
| `cm3588-nas` | `current`, `edge`, `vendor` |
| `coolpi-cm5` | `edge` |
| `coolpi-genbook` | `edge`, `vendor` |
| `cubie-a7z` | `vendor` |
| `cubieboard` | `current`, `edge`, `legacy` |
| `cubieboard2` | `current`, `edge`, `legacy` |
| `cubieboard4` | `current`, `edge` |
| `cubietruck` | `current`, `edge`, `legacy` |
| `cyber-aib-rk3588` | `vendor`, `edge` |
| `dshanpi-a1` | `vendor` |
| `dshanpi-a1-cm5-waveshare-cm5-to-pi5-adapter` | `current`, `edge` |
| `dshanpi-r1` | `current`, `edge`, `vendor` |
| `dusun-dsom-010r` | `current`, `edge` |
| `easepi-r1` | `current`, `edge` |
| `easy-eai-nano` | `vendor` |
| `ebyte-ecb41-pge` | `vendor` |
| `eltay-rm66` | `current`, `vendor`, `edge` |
| `fine3399` | `current`, `edge` |
| `firefly-aibox-k3` | `legacy` |
| `firefly-itx-3588j` | `vendor` |
| `firefly-rk3399` | `current`, `edge` |
| `forlinx-ok3506-s12` | `vendor` |
| `fxblox-rk1` | `vendor` |
| `gl-mt2500` | `edge` |
| `gl-mt2500-v2` | `edge` |
| `graperain-g3568-v2` | `current`, `edge` |
| `hikey960` | `current`, `edge` |
| `hinlink-h28k` | `vendor` |
| `hinlink-h66k` | `current`, `edge` |
| `hinlink-h68k` | `current`, `edge` |
| `hinlink-h88k` | `vendor`, `edge` |
| `hinlink-hnas` | `current`, `edge` |
| `hinlink-ht2` | `vendor` |
| `indiedroid-nova` | `current`, `edge`, `vendor` |
| `khadas-edge` | `current`, `edge` |
| `kickpi-k2b-v2` | `current`, `edge` |
| `kickpik2b` | `current`, `edge` |
| `lckfb-taishanpi` | `vendor`, `current`, `edge` |
| `leez-p710` | `current`, `edge` |
| `lenovo-y700-gen4` | `edge` |
| `lime` | `current`, `edge`, `legacy` |
| `lime-a33` | `current`, `edge`, `legacy` |
| `lime2` | `current`, `edge`, `legacy` |
| `longanpi-3h` | `current`, `edge` |
| `longanpi-4b` | `legacy` |
| `lubancat-3-v2` | `vendor`, `current`, `edge` |
| `lubancat-4` | `current`, `edge` |
| `lubancat2` | `edge` |
| `luckfox-core3566` | `vendor` |
| `luckfox-lyra-plus` | `vendor` |
| `luckfox-lyra-ultra-w` | `vendor` |
| `luckfox-lyra-zero-w` | `vendor` |
| `luckfox-pico-max` | `vendor` |
| `luckfox-pico-mini` | `vendor` |
| `maaxboard-8ulp` | `vendor` |
| `mangopi-m28k` | `vendor` |
| `mangopi-mq` | `edge` |
| `mekotronics-r58-minipc` | `vendor` |
| `mekotronics-r58x` | `vendor` |
| `mekotronics-r58x-4g` | `edge`, `vendor` |
| `mekotronics-r58x-pro` | `edge`, `vendor` |
| `melea1000` | `current`, `edge`, `legacy` |
| `mellowflyc5` | `current`, `edge` |
| `milkv-duos-arm` | `edge` |
| `milkv-duos-riscv` | `edge` |
| `mixtile-blade3` | `vendor`, `edge` |
| `mixtile-core3588e` | `edge`, `vendor` |
| `mixtile-edge2` | `current`, `edge`, `vendor` |
| `mk808c` | `current`, `edge`, `legacy` |
| `mkspi` | `current`, `edge` |
| `nanopct4` | `current`, `edge` |
| `nanopi-neo3-plus` | `current`, `edge` |
| `nanopi-r1` | `current`, `edge`, `legacy` |
| `nanopi-r1s-h5` | `current`, `edge`, `legacy` |
| `nanopi-r28s` | `vendor` |
| `nanopi-r2c` | `current`, `edge` |
| `nanopi-r2s` | `current`, `edge` |
| `nanopi-r2s-plus` | `current`, `edge` |
| `nanopi-r3s` | `current`, `edge` |
| `nanopi-r4se` | `current`, `edge` |
| `nanopi-r5c` | `current`, `edge` |
| `nanopi-r5s` | `current`, `edge` |
| `nanopi-zero2` | `vendor`, `current`, `edge` |
| `nanopia64` | `current`, `edge`, `legacy` |
| `nanopiair` | `current`, `edge`, `legacy` |
| `nanopiduo` | `current`, `edge`, `legacy` |
| `nanopiduo2` | `current`, `edge`, `legacy` |
| `nanopim4` | `current`, `edge` |
| `nanopineo` | `current`, `edge`, `legacy` |
| `nanopineo2` | `current`, `edge`, `legacy` |
| `nanopineo2black` | `current`, `edge`, `legacy` |
| `nanopineo3` | `current`, `edge` |
| `nanopineo4` | `current`, `edge` |
| `nanopineocore2` | `current`, `edge`, `legacy` |
| `nanopineoplus2` | `current`, `edge`, `legacy` |
| `norco-emb-3531` | `current`, `edge` |
| `numaker-iot-ma35d16f90` | `vendor` |
| `odroidm1s` | `current`, `edge` |
| `odroidn2l` | `current`, `edge` |
| `odroidu3` | `current`, `edge` |
| `odroidx2` | `current`, `edge` |
| `olimex-a20-olinuxino-micro` | `current`, `edge`, `legacy` |
| `olimex-teres-a64` | `current`, `edge`, `legacy` |
| `olinux-som-a13` | `current`, `edge`, `legacy` |
| `onecloud` | `current` |
| `orangepi-4a` | `edge` |
| `orangepi-r1` | `current`, `edge`, `legacy` |
| `orangepi-r1plus` | `current`, `edge` |
| `orangepi-r1plus-lts` | `current`, `edge` |
| `orangepi-rk3399` | `current`, `edge` |
| `orangepi2` | `current`, `edge`, `legacy` |
| `orangepi3` | `current`, `edge`, `legacy` |
| `orangepi3b` | `vendor`, `current`, `edge` |
| `orangepi4` | `current`, `edge` |
| `orangepi4pro` | `vendor` |
| `orangepi5-max` | `vendor`, `current`, `edge` |
| `orangepi5-ultra` | `vendor`, `current`, `edge` |
| `orangepi5b` | `edge`, `vendor` |
| `orangepi5pro` | `current`, `edge`, `vendor` |
| `orangepilite` | `current`, `edge`, `legacy` |
| `orangepilite2` | `current`, `edge`, `legacy` |
| `orangepioneplus` | `current`, `edge`, `legacy` |
| `orangepipc` | `current`, `edge`, `legacy` |
| `orangepipcplus` | `current`, `edge`, `legacy` |
| `orangepiplus` | `current`, `edge`, `legacy` |
| `orangepiplus2e` | `current`, `edge`, `legacy` |
| `orangepiprime` | `current`, `edge`, `legacy` |
| `orangepir2s` | `legacy`, `current` |
| `orangepirv2` | `legacy`, `current` |
| `orangepiwin` | `current`, `edge`, `legacy` |
| `orangepizero` | `current`, `edge`, `legacy` |
| `orangepizero2` | `current`, `edge` |
| `orangepizero2w` | `current`, `edge` |
| `orangepizero3` | `current`, `edge` |
| `orangepizeroplus` | `current`, `edge`, `legacy` |
| `orangepizeroplus2-h3` | `current`, `edge`, `legacy` |
| `orangepizeroplus2-h5` | `current`, `edge`, `legacy` |
| `pbstvstick` | `current`, `edge` |
| `pcduino3` | `current`, `edge`, `legacy` |
| `photonicat2` | `current` |
| `phytiumpi` | `vendor` |
| `pine64` | `current`, `edge`, `legacy` |
| `pine64so` | `current`, `edge`, `legacy` |
| `pinebook-a64` | `current`, `edge`, `legacy` |
| `pinebook-pro` | `current`, `edge` |
| `pinecube` | `current`, `edge`, `legacy` |
| `pineh64` | `current`, `edge`, `legacy` |
| `pineh64-b` | `current`, `edge`, `legacy` |
| `pocketchip-sd` | `current` |
| `qemu-uboot-arm64` | `current`, `edge` |
| `qemu-uboot-x86` | `current`, `edge` |
| `qemu-uefi-x86` | `current`, `edge`, `legacy` |
| `quartz64-zero` | `current`, `edge` |
| `quartz64a` | `current`, `edge` |
| `quartz64b` | `current`, `edge` |
| `radxa-cubie-a5e` | `current`, `edge` |
| `radxa-e20c` | `vendor` |
| `radxa-zero2` | `current`, `edge` |
| `recomputer-rk3576-module-devkit` | `vendor` |
| `recore` | `current`, `edge` |
| `retro-lite-cm5` | `vendor` |
| `retroidpocket-rp5` | `current`, `edge` |
| `retroidpocket-rpmini` | `current`, `edge` |
| `rk3328-heltec` | `current`, `edge` |
| `rk3566-box-demo` | `current`, `edge` |
| `roc-rk3399-pc` | `current`, `edge` |
| `rock-3c` | `current`, `edge` |
| `rock-4se` | `current`, `edge` |
| `rock-5-cm-rpi-cm4-io` | `vendor` |
| `rock-5-cmio` | `vendor` |
| `rock64` | `current`, `edge` |
| `rockpi-4a` | `current`, `edge` |
| `rockpi-4b` | `current`, `edge` |
| `rockpi-4c` | `current`, `edge` |
| `rockpi-4cplus` | `current`, `edge` |
| `rockpi-n10` | `current`, `edge` |
| `smart-am40` | `current`, `edge` |
| `sovol-sv08` | `current`, `edge` |
| `sovol-sv08-max` | `current`, `edge` |
| `station-m1` | `current`, `edge` |
| `station-m2` | `current`, `edge`, `vendor` |
| `station-m3` | `vendor`, `current` |
| `station-p1` | `current`, `edge` |
| `station-p2` | `current`, `edge` |
| `tinker-edge-r` | `current`, `edge` |
| `tinkerboard-2` | `current`, `edge` |
| `tritium-h3` | `current`, `edge`, `legacy` |
| `tritium-h5` | `current`, `edge`, `legacy` |
| `turing-rk1` | `current`, `edge`, `vendor` |
| `uefi-riscv64` | `current`, `edge`, `legacy` |
| `visionfive2` | `vendor` |
| `walnutpi-1b` | `current`, `edge` |
| `walnutpi-1b-ddr3` | `current`, `edge` |
| `walnutpi-box` | `current`, `edge` |
| `walnutpi-zerow` | `current`, `edge` |
| `xc3399fr` | `current`, `edge` |
| `xiaobao-nas` | `current`, `edge` |
| `xiaomi-sheng` | `edge` |
| `xpressreal-t3` | `vendor` |
| `yy3568` | `current`, `edge`, `vendor` |
| `zeropi` | `current`, `edge` |

## TV Box (.tvb) (14 个)

| Board | 内核分支 |
|-------|---------|
| `aml-s805-mxq` | `current` |
| `aml-s9xx-box` | `current`, `edge` |
| `aml-t95z-plus` | `edge` |
| `beelinkx2` | `current`, `edge`, `legacy` |
| `h96-tvbox-3566` | `current`, `edge` |
| `jp-tvbox-3566` | `current`, `edge` |
| `rk322x-box` | `current`, `edge` |
| `rk3318-box` | `current`, `edge` |
| `sunvell-r69` | `current`, `edge`, `legacy` |
| `tanix-tx6` | `current`, `edge`, `legacy` |
| `x96-mate` | `current`, `edge` |
| `x96q` | `current` |
| `xt-q8l-v10` | `current`, `edge` |
| `z28pro` | `current` |

## 开发中 (.wip) (2 个)

| Board | 内核分支 |
|-------|---------|
| `orangepi-cm5` | `current`, `edge` |
| `ztl-a568` | `current`, `edge` |

## 已停止维护 (.eos) (33 个)

| Board | 内核分支 |
|-------|---------|
| `bananapim2` | `current`, `legacy` |
| `beaglev` | `edge` |
| `cubietruckplus` | `current`, `edge`, `legacy` |
| `fe-som-rk3399` | `current`, `edge` |
| `imx7sabre` | `current`, `legacy` |
| `lamobo-r1` | `current`, `edge` |
| `licheepi-4a` | `current`, `edge`, `legacy` |
| `lime-a10` | `current`, `edge` |
| `macchiatobin-doubleshot` | `current`, `edge` |
| `microzed` | `legacy` |
| `miqi` | `current`, `edge` |
| `nanopct6` | `current`, `edge`, `vendor` |
| `nanopct6-lts` | `current`, `edge`, `vendor` |
| `nanopi-m6` | `current`, `edge`, `vendor` |
| `nanopi-r6c` | `current`, `edge`, `vendor` |
| `nanopi-r6s` | `current`, `edge`, `vendor` |
| `nanopim1` | `current`, `edge`, `legacy` |
| `nanopim1plus` | `current`, `edge`, `legacy` |
| `nanopim1plus2` | `current`, `edge`, `legacy` |
| `nezha` | `edge` |
| `olimex-som-a20` | `current`, `edge` |
| `olimex-som204-a20` | `current`, `edge` |
| `orangepi` | `current`, `edge`, `legacy` |
| `orangepimini` | `current`, `edge`, `legacy` |
| `panther-x2` | `current`, `edge` |
| `pcduino2` | `current`, `edge` |
| `pcduino3nano` | `current`, `edge`, `legacy` |
| `star64` | `vendor` |
| `unleashed` | `edge` |
| `unmatched` | `edge` |
| `virtual-qemu` | `current` |
| `visionfive` | `edge` |
| `wdk2023` | `wdk2023` |
