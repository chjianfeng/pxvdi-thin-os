# PXVDI ThinOS

基于 Debian 的瘦客户端操作系统，为 PXVDI 定制。

支持本地 ISO 构建和 Armbian 开发板/TV Box 构建。

## 目录结构

```
pxvdi-thin-os/
├── buildrootfs.sh              # 核心构建脚本（ISO / Armbian 共用）
├── config/                     # 配置文件（openbox, lightdm, 环境变量等）
├── bizhi.jpg                   # 壁纸
├── rc.xml                      # Openbox 窗口管理器配置
├── grub.cfg                    # GRUB 引导配置
└── .github/
    ├── scripts/
    │   ├── customize-image.sh      # Armbian chroot 钩子
    │   └── prepare-userpatches.sh  # 组装 Armbian userpatches
    └── workflows/
        ├── build-devboard.yml      # 开发板构建 CI
        └── build-tvbox.yml         # TV Box 构建 CI
```

## 本地 ISO 构建

支持 amd64\arm64\loongarch64 架构。

```bash
# 完整构建（需要 root）
sudo ./buildrootfs.sh rebuild

# 增量更新（复用已有 rootfs）
sudo ./buildrootfs.sh update

# 查看帮助
./buildrootfs.sh -h
```

## GitHub Actions 构建

可以利用github actions 远程构建嵌入式系统镜像

### 开发板  armbian 分支

手动触发 `workflow_dispatch`，参数：

| 参数 | 说明 | 示例 |
|------|------|------|
| `board` | Armbian 板型名 | `rock-5b` |
| `branch` | 内核分支 | `vendor` / `current` / `edge` |

> 完整板子列表见 [docs/armbian-boards.md](docs/armbian-boards.md)

###  ophub  armbian 分支

先用 Armbian 构建 `aml-s9xx-box` 基础镜像，再用 [ophub/amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) 二次打包。

手动触发 `workflow_dispatch`，参数：

| 参数 | 说明 | 示例 |
|------|------|------|
| `branch` | 内核分支 | `current` / `edge` |
| `amlogic_soc` | ophub board 名，多个用 `_` 分隔 | `s905x3` 或 `s905x3_s922x` |

> 完整设备列表见 [docs/ophub-boards.md](docs/ophub-boards.md)


## 配置定制

用户可以克隆本仓库，修改下面信息 定制iso 或者 系统镜像

### 瘦客户端定制
`config/pxvdiconfig.json` 这里是瘦客户端的配置文件，可以修改其中的配置来定制瘦客户端的行为。

- logo_path
    pxvdi瘦客户端的logo 位置
- server
    pxvdi服务端地址
- footer
    底部版权信息文字
- connecttype
    默认的连接类型，pxvdi 或 freerdp3 
- macmode
    是否为mac模式

### 系统定制
    
- bizhi.jpg 瘦客户端的壁纸


## 购买许可席位

可以 

- 邮件咨询: service@lierfang.com
- 微信服务号: 梨儿方
- 官网: https://www.lierfang.com
- 更多的文档: https://docs.pxvdi.lierfang.com