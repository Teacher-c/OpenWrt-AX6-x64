#!/bin/bash

#设置kennel和root分区大小
echo "CONFIG_TARGET_KERNEL_PARTSIZE=64" >> .config
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=2048" >> .config

#不打包EXT4FS固件
echo "CONFIG_TARGET_ROOTFS_EXT4FS=n" >> .config

#增加组件一些基础插件
echo "CONFIG_PACKAGE_luci-compat=y" >> .config
echo "CONFIG_PACKAGE_luci-lib-ipkg=y" >> .config
echo "CONFIG_PACKAGE_ipv6helper=y" >> .config
echo "CONFIG_PACKAGE_ip6tables-extra=y" >> .config
echo "CONFIG_PACKAGE_ip6tables-mod-nat=y" >> .config
echo "CONFIG_PACKAGE_unzip=y" >> .config
echo "CONFIG_PACKAGE_coreutils=y" >> .config
echo "CONFIG_PACKAGE_coreutils-sort=y" >> .config
echo "CONFIG_PACKAGE_curl=y" >> .config
echo "CONFIG_PACKAGE_htop=y" >> .config
echo "CONFIG_PACKAGE_bash=y" >> .config
echo "CONFIG_PACKAGE_autocore=y" >> .config

#增加主题
echo "CONFIG_PACKAGE_luci-theme-$OWRT_THEME=y" >> .config
#echo "CONFIG_PACKAGE_luci-app-$OWRT_THEME-config=y" >> .config

#根据源码来修改
if [[ $OWRT_URL != *"lede"* ]] ; then
  #增加luci界面
  echo "CONFIG_PACKAGE_luci=y" >> .config
  echo "CONFIG_LUCI_LANG_zh_Hans=y" >> .config
fi


if [[ "$OWRT_URL" == "https://github.com/padavanonly/immortalwrt.git" ]]; then
  echo "CONFIG_PACKAGE_zram-swap=n" >> .config
  echo "CONFIG_PACKAGE_miniupnpd=n" >> .config
  echo "CONFIG_PACKAGE_luci-app-upnp=n" >> .config
  echo "CONFIG_PACKAGE_qos-scripts=n" >> .config
  echo "CONFIG_PACKAGE_luci-app-eqos-mtk=n" >> .config
  echo "CONFIG_PACKAGE_luci-app-mwan3helper-chinaroute=n" >> .config
fi
