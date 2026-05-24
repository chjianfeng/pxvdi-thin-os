#!/bin/bash
arch=`dpkg-architecture  -q DEB_HOST_ARCH`
release="trixie"
script_path=$(readlink -f "$0")
DIR=$(dirname "$script_path")
isopath=$DIR/iso/isofs
targetdir="$DIR/iso/rootfs"
rootdisks="/dev/nbd8"
modules="hfs hfsplus cdrom sd_mod sr_mod loop squashfs iso9660 overlay nls_cp437 nls_iso8859-1 nls_utf8 nls_ascii vfat"
rockchip="false"
searchfilename=$(date +%s%N | md5sum | head -c 10)

# 公共包列表 — ISO 和 Armbian 模式共用，添加新包只改这里
PXVDI_BASE_PACKAGES="udiskie chrony console-setup zstd gzip bash-completion locales \
  libmagic1 network-manager-gnome wpagui iw gnome-network-displays \
  xserver-xorg-input-all lightdm network-manager xfonts-intl-chinese \
  virt-viewer openbox xorg pavucontrol pulseaudio \
  feh xfonts-wqy plymouth-themes plymouth-x11 \
  fonts-noto-cjk gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-ugly \
  gstreamer1.0-plugins-rtp gstreamer1.0-plugins-bad gstreamer1.0-nice initramfs-tools \
  system-config-printer printer-driver-all cups rsync pciutils \
  fcitx5 fcitx5-chinese-addons fcitx5-frontend-all fcitx5-config-qt \
  fcitx5-mozc fcitx5-anthy im-config"

case "$arch" in
  arm64)    grub_prefix="arm64";        grub_file="BOOTAA64.EFI" ;;
  amd64)    grub_prefix="x86_64";       grub_file="BOOTX64.EFI";       grub_bin="grub-pc-bin grub-efi-ia32-bin" ;;
  loong64)  grub_prefix="loongarch64";  grub_file="BOOTLOONGARCH64.EFI" ;;
  riscv64)  grub_prefix="riscv64";      grub_file="BOOTRISCV64.EFI" ;;
esac


######################## 工具函数 ########################

errlog(){
	if [ $? != 0 ];then
		echo -e "\033[31m[ERROR] $1\033[0m"
		clean
		exit 1
	fi
}

run_in_target(){
  if [ -n "$targetdir" ]; then
    chroot "$targetdir" "$@"
  else
    "$@"
  fi
}

disksetup(){
  echo "check disk"
  test -f pxvdi.raw && rm  pxvdi.raw
  echo "enable nbd mod"
  modprobe nbd
  echo "create disks"
  dd if=/dev/zero of=pxvdi.raw bs=1G count=6
  echo "modprobe disk"
  qemu-nbd -c $rootdisks pxvdi.raw || echo ok
}

######################## ISO 专用：磁盘 / 引导 / 镜像 ########################

diskformat(){
	echo "create gpt"
	sgdisk -GZ $rootdisks >/dev/null 2>&1
	echo "create bios parttion"

	sgdisk -a1 -n1:34:2047  -t1:EF02  $rootdisks >/dev/null 2>&1
	echo "create efi parttion"

	sgdisk -a1 -n2:1M:+512M -t2:EF00 $rootdisks >/dev/null 2>&1

	echo "create root parttion"
	sgdisk -a1 -n3:513M:-256M  $rootdisks >/dev/null 2>&1

  mkfs.ext4 -F "$rootdisks"p3
  mkfs.vfat --codepage=437 -F 32 "$rootdisks"p2

  mount -t ext4 "$rootdisks"p3 $targetdir
  e2label "$rootdisks"p3 pxvdirootdisk
}


######################## 共享函数：安装 / 配置 ########################

debian_start(){
  echo "create debian base"
  if [ "$arch" == "loong64" ]; then
    debootstrap --variant=buildd --no-check-gpg --arch=$arch sid $targetdir https://mirrors.lierfang.com/debian-ports/$release
    echo "deb [trusted=yes check-valid-until=no] https://mirrors.lierfang.com/debian-ports/$release sid main" > /etc/apt/sources.list
    echo 'APT { Get { AllowUnauthenticated "1"; }; };' > $targetdir/etc/apt/apt.conf.d/99allow_unauth
  else
    debootstrap --arch=$arch $release $targetdir https://mirrors.ustc.edu.cn/debian/
  fi
  
  echo "create desktop env"
  install_base_packages grub-efi grub-efi-$arch $grub_bin
  echo "LABEL=pxvdirootdisk / ext4 defaults 0 0 " > $targetdir/etc/fstab
}

install_base_packages(){
  # $@ = 各模式额外追加的包（ISO 传 grub，armbian 传 locales-all 等）
  echo "locales locales/default_environment_locale select zh_CN.UTF-8" | run_in_target debconf-set-selections
  echo "locales locales/locales_to_be_generated select en_US.UTF-8 UTF-8, zh_CN.UTF-8 UTF-8" | run_in_target debconf-set-selections
  DEBIAN_FRONTEND=noninteractive run_in_target apt-get install -y \
      $PXVDI_BASE_PACKAGES "$@" || errlog "base apt install failed"
  DEBIAN_FRONTEND=noninteractive run_in_target dpkg-reconfigure --frontend noninteractive locales
}

user_set(){
  # create user
  run_in_target groupadd -f autologin  
  run_in_target groupadd -f nopasswdlogin
  run_in_target usermod -aG autologin,nopasswdlogin root
  run_in_target passwd -d root
}


openbox_config(){
  echo "openbox_config"
  install -D -m 0644 "$DIR/config/openbox/autostart"   "$targetdir/etc/xdg/openbox/autostart"
  install -D -m 0644 "$DIR/config/openbox/menu.xml"    "$targetdir/etc/xdg/openbox/menu.xml"
  install -D -m 0644 "$DIR/config/openbox/menu-zh.xml" "$targetdir/etc/xdg/openbox/menu-zh.xml"
  install -D -m 0644 "$DIR/config/openbox/menu-en.xml" "$targetdir/etc/xdg/openbox/menu-en.xml"
  install -D -m 0644 "$DIR/config/openbox/menu-jp.xml" "$targetdir/etc/xdg/openbox/menu-jp.xml"
  install -D -m 0755 "$DIR/config/bin/langsetting"     "$targetdir/usr/bin/langsetting"
  mkdir -p "$targetdir/root/.config/openbox/"
  cp "$DIR/rc.xml" "$targetdir/root/.config/openbox/"
}

lightdm_config(){
  echo "lightdm_config"
  install -D -m 0644 "$DIR/config/lightdm/lightdm.conf" "$targetdir/etc/lightdm/lightdm.conf"
  install -D -m 0644 "$DIR/config/environment"           "$targetdir/etc/environment"
  sed -i "/root/d" "$targetdir/etc/pam.d/lightdm-autologin"
}

linux_firmware(){
    if [ ! -d "$DIR/firmware" ]; then
      git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git --depth=1 $DIR/firmware || errlog "clone firmware failed"
    fi
    # 用官方脚本安装，自动创建符号链接
    cd $DIR/firmware
    ./copy-firmware.sh $targetdir/lib/firmware/
    cd ..
 
    rm -rf $targetdir/lib/firmware/nvidia $targetdir/lib/firmware/qcom $targetdir/lib/firmware/netronome \
    $targetdir/lib/firmware/mellanox $targetdir/lib/firmware/mrvl
 
    if [ "$arch" == "arm64" ]; then
      rm -rf $targetdir/lib/firmware/intel $targetdir/lib/firmware/amdgpu
    fi
    if [ "$arch" == "loong64" ]; then
      cp -r  $DIR/loonggpu $targetdir/lib/firmware/
    fi
}


pxvdi_deb(){
  curl -fL https://mirrors.lierfang.com/pxcloud/lierfang.gpg \
      -o $targetdir/etc/apt/trusted.gpg.d/lierfang.gpg || errlog "fetch gpg failed"
  echo "deb https://mirrors.lierfang.com/pxcloud/pxvdi/ $release main" > $targetdir/etc/apt/sources.list.d/pxvdi.list
  run_in_target apt-get update || errlog "apt update failed"

  # 公共 pxvdi 包
  local _pxvdi_pkgs="pxvdi-thin-client pxvdistream freerdp3-x11 freerdp3-sdl freerdp3-wayland pxvdistreamclient pxvdi-theme"
  # ISO 模式额外需要自定义内核和安装器
  if [ "$MODE" != "armbian" ]; then
    _pxvdi_pkgs="$_pxvdi_pkgs linux-image-6.6.151-pxvdi pxvdi-boot-initramfs-tools pxvdi-installer"
  fi
  DEBIAN_FRONTEND=noninteractive run_in_target apt-get install -y $_pxvdi_pkgs || errlog "apt install pxvdi failed"

  # rockchip 加速包
  if [ "$rockchip" == "true" ] || [[ "${ARMBIAN_LINUXFAMILY:-}" =~ ^(rockchip|rk35xx) ]]; then
    DEBIAN_FRONTEND=noninteractive run_in_target apt-get install -y \
        gstreamer1.0-rockchip1 librga2 librockchip-mpp1 librockchip-vpu0 2>/dev/null \
        || run_in_target apt-get install -y gstreamer-rockchip 2>/dev/null || true
  fi

  run_in_target pxvdistream install || true
  run_in_target systemctl enable pxvdistream || true
}

pxvdi_config(){
  echo "pxvdi" > $targetdir/etc/hostname
  mkdir -p $targetdir/root/.lierfang/
  mkdir -p $targetdir/root/.config/pulse

  # 壁纸
  cp "$DIR/bizhi.jpg" "$targetdir/usr/share/bizhi.jpg" || true

  # pxvdi 配置文件
  [ -f "$DIR/config/pxvdithinclientconfig.json" ] && \
    cp "$DIR/config/pxvdithinclientconfig.json" "$targetdir/root/.lierfang/" || true
  [ -f "$DIR/config/pxvdistream.conf" ] && \
    cp "$DIR/config/pxvdistream.conf" "$targetdir/root/.lierfang/" || true

  # pxvdi 环境变量
  install -D -m 0644 "$DIR/config/default/pxvdi" "$targetdir/etc/default/pxvdi"

  # plymouth 主题
  cp $targetdir/usr/share/plymouth/themes/pxvdi/watermark.png \
    $targetdir/usr/share/desktop-base/debian-logos/logo-text-version-64.png || true
  if [ -f "$DIR/config/custom.png" ]; then
    cp $DIR/config/custom.png $targetdir/usr/share/desktop-base/debian-logos/logo-text-version-64.png || true
  fi
  if [ -f "$DIR/config/loongson" ]; then
    mkdir -p $targetdir/usr/share/pxvdi/
    cp $DIR/config/loongson $targetdir/usr/share/pxvdi/ || true
  fi

  run_in_target plymouth-set-default-theme -R pxvdi || true
}


prepare_chroot(){
	#挂载roofs之前准备
	echo "prepare chroot"
	mount -n -t tmpfs tmpfs $targetdir/tmp
	mount -n -t proc /proc  $targetdir/proc
	mount -n -o bind /dev  $targetdir/dev
	mount -n -o bind /dev/pts  $targetdir/dev/pts
	mount -n -t sysfs sysfs $targetdir/sys 
}

clean_chroot(){
	echo "clean chroot"
	echo clean
  umount -l $targetdir/boot/efi
    echo "start mount proc"
	umount -l $targetdir/proc
  echo "mount proc"
	umount -l $targetdir/sys
	umount -l $targetdir/dev/pts
	umount -l $targetdir/dev
	umount -l $targetdir/boot/efi/
 	umount -l $targetdir/run
  umount -l $targetdir/tmp
	umount -l $targetdir/mnt/run
  umount -l /tmp/efi
}


clean(){
  clean_chroot
  umount -l $targetdir
  qemu-nbd -d $rootdisks
}

create_squashfs(){
  rm -rf $isopath/pxvdi.img 
  mksquashfs $targetdir $isopath/pxvdi.img || errlog "create squashfs failed"
}

create_isofs(){
  mkdir $isopath/EFI/BOOT -p
  mkdir $isopath/boot/
  touch $isopath/boot/$searchfilename
  cp -r $targetdir/usr/lib/grub $isopath/boot/
}

mkefi_img(){
  create_grub_cfg
  echo "create efi img"
    dd if=/dev/zero of=$isopath/boot/grub/efi.img bs=512 count=20480
    mkfs.fat -F 16 --codepage=437 -n 'EFI' $isopath/boot/grub/efi.img
    rm /tmp/efi -rf
    mkdir /tmp/efi/
    mount $isopath/boot/grub/efi.img /tmp/efi
    rsync -av $isopath/EFI  /tmp/efi  ||errlog "do EFI file failed"
  
    umount -l /tmp/efi
}

check_env(){
  local cmds="debootstrap chroot mksquashfs xorriso mkfs.fat mkfs.ext4 \
    dd mount umount rsync curl git sgdisk modprobe \
    e2label sed cat cp rm mkdir"
  local missing=""
  for cmd in $cmds; do
    if ! command -v "$cmd" &>/dev/null; then
      missing="$missing $cmd"
    fi
  done
  if [ -n "$missing" ]; then
    echo -e "\033[31m[ERROR] 缺少以下命令:$missing\033[0m"
    exit 1
  fi
  echo "环境检查通过"
}

grub_install(){
  for module in $modules; do
    echo "$module" >> $targetdir/etc/initramfs-tools/modules
  done
  chroot $targetdir update-initramfs -kall -u || errlog "update initramfs failed"
  cp $targetdir/boot/initrd.img-* $isopath/boot/initrd.img  ||errlog "do copy initrd failed"
	cp $targetdir/boot/vmlinuz-*  $isopath/boot/linux26  ||errlog "do copy kernel failed"
  echo "do grub install"
  rm -rf $isopath/EFI/
  mkdir $isopath/EFI/BOOT/ -p
  mkdir $targetdir/boot/efi  -p 

  chroot $targetdir grub-mkimage -o /boot/efi/$grub_file -O $grub_prefix-efi -p /EFI/BOOT/ \
  boot linux chain normal configfile \
  part_gpt part_msdos fat iso9660 udf \
  test true keystatus loopback regexp probe \
  efi_gop all_video gfxterm font \
  echo read help ls cat halt reboot lvm ext2 xfs  hfsplus hfs \
  acpi search_label search search_fs_file search_fs_uuid \
  serial terminfo terminal zfs btrfs efifwsetup  || errlog  "create boot "

  if [ "$arch" = "amd64" ];then
    echo "create ia32 efi target efi file"
    chroot $targetdir grub-mkimage -o /boot/efi/bootia32.efi -O i386-efi -p /EFI/BOOT/ \
      boot linux chain normal configfile \
      part_gpt part_msdos fat iso9660 udf \
      test true keystatus loopback regexp probe \
      efi_gop all_video gfxterm font \
      echo read help ls cat halt reboot lvm ext2 xfs  hfsplus hfs \
      acpi search_label search search_fs_file search_fs_uuid \
      serial terminfo terminal zfs btrfs efifwsetup \
      usbserial_pl2303 usbserial_usbdebug  usbserial_ftdi  usbserial_common usb smbios  || errlog  "create i32 boot "
  fi

  rsync -av $targetdir/boot/efi/* $isopath/EFI/BOOT/
  cp $DIR/grub.cfg $isopath/boot/grub/  ||errlog "do copy grub cfg  failed"

}

create_grub_cfg(){

  cat > $isopath/EFI/BOOT/grub.cfg << EOF
search --file --set=root /boot/$searchfilename
set prefix=(\${root})/boot/grub
source \${prefix}/grub.cfg
insmod part_acorn
insmod part_amiga
insmod part_apple
insmod part_bsd
insmod part_dfly
insmod part_dvh
insmod part_gpt
insmod part_msdos
insmod part_plan
insmod part_sun
insmod part_sunpc
EOF

}

create_iso(){
    if [ "$arch" == "amd64" ];then
      create_iso_x86
    else 
      create_iso_efi
    fi 
}

create_iso_efi(){
  cd $isopath

  xorriso -as mkisofs \
  -V 'PXVDI' \
  -o pxvdi.iso \
  -iso-level 3 \
  -r -J \
  -partition_offset 16 \
  -append_partition 2 0xef ./boot/grub/efi.img \
  -appended_part_as_gpt \
  -c '/boot/boot.cat' \
  -eltorito-alt-boot \
  -e '--interval:appended_partition_2:all::' \
  -no-emul-boot \
  .
}

create_iso_x86(){
  cd $isopath
  echo "create iso.mbr"
  dd if=$targetdir/usr/lib/grub/i386-pc/boot.img of=$isopath/boot/iso.mbr bs=512 count=1

  # 生成 core.img（使用 i386-pc 格式）
  chroot $targetdir grub-mkimage -p /boot/grub -o /core.img -O i386-pc \
    biosdisk boot linux chain normal configfile \
    part_gpt part_msdos fat iso9660 udf \
    test true keystatus loopback regexp probe \
    all_video gfxterm font \
    echo read help ls cat halt reboot lvm ext2 xfs hfsplus hfs \
    acpi search_label search search_fs_file search_fs_uuid \
    serial terminfo terminal

  # 拼接 cdboot.img + core.img 生成 eltorito.img
  cat $targetdir/usr/lib/grub/i386-pc/cdboot.img $targetdir/core.img > $isopath/boot/eltorito.img
  rm $targetdir/core.img

  xorriso -as mkisofs  \
    -V 'PXVDI' \
    -o pxvdi-$arch.iso \
    --grub2-mbr --interval:local_fs:0s-15s:zero_mbrpt,zero_gpt,zero_apm:'./boot/iso.mbr' \
    --modification-date=$isodate2 \
    -partition_cyl_align off \
    -partition_offset 0 \
    -partition_hd_cyl 67 \
    -partition_sec_hd 32 \
    -apm-block-size 2048 \
    -hfsplus \
    -efi-boot-part --efi-boot-image \
    -c '/boot/boot.cat' \
    -b '/boot/eltorito.img' \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    --grub2-boot-info \
    -eltorito-alt-boot \
    -iso-level 3 \
    -e '/boot/grub/efi.img' \
    -no-emul-boot \
    -boot-load-size 16384 \
    .
}

######################## 模式入口 ########################

usage(){
  cat <<EOF
Usage: $0 [MODE]

Modes:
  rebuild   完全重来：清理 \$DIR/iso，从 debootstrap 开始全量构建（默认）
  update    增量更新：复用已有 rootfs，apt dist-upgrade 后重新生成 ISO
  armbian   Armbian 构建钩子：在 chroot 内定制 PXVDI 瘦客户端系统
  -h|--help 显示本帮助

EOF
}

mode_rebuild(){
  echo "==> 模式: rebuild (完全重建)"
  clean
  rm -rf $DIR/iso
  mkdir -p $targetdir

  debian_start ||  errlog "create debian base failed"
  linux_firmware
  user_set ||  errlog "create user failed"
  openbox_config || errlog "openbox set failed"
  lightdm_config || errlog "lightdm set failed"
  pxvdi_deb  || errlog "pxvdi bin install failed"
  pxvdi_config

  prepare_chroot
  create_isofs
  grub_install
  clean
  create_squashfs
  mkefi_img
  create_iso
  clean
}

apt_dist_upgrade(){
  echo "==> chroot 内执行 apt update && apt dist-upgrade"
  chroot $targetdir apt update || errlog "apt update failed"
  DEBIAN_FRONTEND=noninteractive chroot $targetdir apt -y \
    -o Dpkg::Options::=--force-confdef \
    -o Dpkg::Options::=--force-confold \
    dist-upgrade || errlog "apt dist-upgrade failed"
  DEBIAN_FRONTEND=noninteractive chroot $targetdir apt -y autoremove --purge || true
  chroot $targetdir apt clean || true
}

mode_update(){
  echo "==> 模式: update (增量更新)"
  if [ ! -d "$targetdir" ] || [ ! -x "$targetdir/usr/bin/apt" ]; then
    echo -e "\033[31m[ERROR] 未找到可用的 rootfs ($targetdir)，请先执行 rebuild 模式\033[0m"
    exit 1
  fi

  # 清理上一次的 isofs 产物，但保留 rootfs
  rm -rf $isopath
  mkdir -p $isopath

  prepare_chroot || errlog "prepare chroot failed"
  apt_dist_upgrade
  pxvdi_config

  create_isofs
  grub_install
  clean
  create_squashfs
  mkefi_img
  create_iso
  clean
}

###############################################################################
# Armbian 模式 — 在 Armbian 构建框架的 chroot 内执行
# customize-image.sh 调用: buildrootfs.sh armbian $RELEASE $LINUXFAMILY $BOARD $BUILD_DESKTOP
###############################################################################

deArmbian() {
    echo "[pxvdi] de-Armbian"
    for svc in armbian-firstrun armbian-firstrun-config armbian-firstlogin \
               armbian-zram-config armbian-ramlog \
               armbian-led-state armbian-disk-health armbian-hardware-monitor \
               armbian-hardware-optimize ; do
        systemctl disable "$svc" 2>/dev/null || true
        systemctl mask    "$svc" 2>/dev/null || true
    done
    rm -f /etc/update-motd.d/*armbian* /etc/update-motd.d/10-armbian-header \
          /etc/update-motd.d/30-armbian-sysinfo /etc/update-motd.d/35-armbian-tips \
          /etc/update-motd.d/41-armbian-config
    rm -f /etc/profile.d/armbian-*.sh /etc/profile.d/check_first_login*.sh
    [ -f /etc/issue.net ] && echo "PXVDI ThinClient \\n \\l" > /etc/issue.net
    [ -f /etc/issue ]     && echo "PXVDI ThinClient \\n \\l" > /etc/issue
    if [ -f /etc/os-release ]; then
        sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="PXVDI ThinClient (based on Debian)"/' /etc/os-release
        sed -i 's/^NAME=.*/NAME="PXVDI"/' /etc/os-release
    fi
    if [ -f /etc/armbian-release ]; then
        sed -i 's/^VENDOR=.*/VENDOR="PXVDI"/' /etc/armbian-release
        grep -q '^VENDOR=' /etc/armbian-release || echo 'VENDOR="PXVDI"' >> /etc/armbian-release
        sed -i 's|^VENDORURL=.*|VENDORURL="https://lierfang.com"|' /etc/armbian-release || true
    fi
    rm -f /root/.not_logged_in_yet
    chage -d 99999 root || true
    DEBIAN_FRONTEND=noninteractive apt-get purge -y armbian-config armbian-zsh 2>/dev/null || true
}

mode_armbian() {
    echo "==> 模式: armbian (Armbian customize-image hook)"
    targetdir=""
    ARMBIAN_LINUXFAMILY="${3:-}"

    # 确保 apt 源可用
    if [ ! -f /etc/apt/sources.list.d/debian.sources ] && \
       ( [ ! -f /etc/apt/sources.list ] || [ ! -s /etc/apt/sources.list ] ); then
        cat > /etc/apt/sources.list.d/debian-temp.sources <<SREOF
Types: deb
URIs: http://deb.debian.org/debian
Suites: ${release} ${release}-updates ${release}-backports
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
SREOF
    fi
    apt-get update || errlog "apt update failed"

    install_base_packages locales-all plymouth xterm desktop-base
    user_set
    openbox_config
    lightdm_config
    pxvdi_deb
    pxvdi_config
    deArmbian

    # 清理
    rm -f /etc/apt/sources.list.d/debian-temp.sources
    apt-get autoremove -y --purge || true
    apt-get clean
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb
}

echo "This is pxvdi ThinOS install scripts"
isodate=`date +"%Y-%m-%d-%H-%M-%S-00"`
isodate2=`echo $isodate|sed  "s/-//g"`

MODE="${1:-rebuild}"
case "$MODE" in
  -h|--help) usage; exit 0 ;;
  rebuild)   check_env; mode_rebuild ;;
  update)    check_env; mode_update ;;
  armbian)   mode_armbian "$@" ;;
  *)         echo "未知模式: $MODE"; usage; exit 1 ;;
esac
