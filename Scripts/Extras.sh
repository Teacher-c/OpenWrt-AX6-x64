#!/bin/bash
#设置kennel和root分区大小
echo "CONFIG_TARGET_KERNEL_PARTSIZE=64" >> .config
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=2048" >> .config

#不打包EXT4FS固件
echo "CONFIG_TARGET_ROOTFS_EXT4FS=n" >> .config

# Compiler Optimization
#编译和链接过程中使用垃圾回收段功能，更高效地利用存储空间和提高程序加载速度
#echo "CONFIG_USE_GC_SECTIONS=y" >> .config
#LTO编译器优化技术提高性能，减小最终生成的二进制文件的大小
#echo "CONFIG_USE_LTO=y" >> .config
#使用mold 链接器加快编译速度
#echo "CONFIG_USE_MOLD=y" >> .config
#在编译 zlib 库时使用了优化速度的配置
#echo "CONFIG_ZLIB_OPTIMIZE_SPEED=y" >> .config
#启用 Zstandard（一种压缩算法）的优化编译选项 -O3
#echo "CONFIG_ZSTD_OPTIMIZE_O3=y" >> .config

# Compiler safe setting
#启用 PIE 可以提高系统的安全性，因为它允许操作系统在不同的内存地址加载可执行文件，从而使攻击者更难预测内存地址
#echo "CONFIG_GCC_DEFAULT_PIE=y" >> .config
#RELRO 是一种内存保护技术，用于增强二进制文件的安全性，防止特定类型的内存损坏攻击
#echo "CONFIG_PKG_RELRO_PARTIAL=y" >> .config

# Kernel CONFIG
#启用内核调试
#echo "CONFIG_COLLECT_KERNEL_DEBUG=y" >> .config
#perf events 是 Linux 内核中的一个框架，用于收集硬件和软件性能数据
#echo "CONFIG_KERNEL_PERF_EVENTS=y" >> .config
#启用动态调试
#echo "CONFIG_KERNEL_DYNAMIC_DEBUG=y" >> .config
#启用 ARM 处理器上的性能监控单元，用于收集处理器性能数据
#echo "CONFIG_KERNEL_ARM_PMU=y" >> .config
#启用了一系列用于开发和调试的特性和功能
#echo "CONFIG_DEVEL=y" >> .config
#启用 ccache 工具进行编译时的缓存，加快编译速度
#echo "CONFIG_CCACHE=y" >> .config
#虚构的配置选项？可能会涉及与专利相关的一些特性
#echo "CONFIG_BUILD_PATENTED=y" >> .config
#用于启用实验性功能
#echo "CONFIG_EXPERIMENTAL=y" >> .config

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

#配置dnsmasq-full
echo "CONFIG_PACKAGE_dnsmasq=n" >> .config
echo "CONFIG_DEFAULT_dnsmasq-full=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq-full=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq_full_dhcp=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq_full_dnssec=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq_full_auth=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq_full_nftset=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq_full_conntrack=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq_full_noid=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq_full_tftp=y" >> .config

#增加主题
echo "CONFIG_PACKAGE_luci-theme-$OWRT_THEME=y" >> .config
#echo "CONFIG_PACKAGE_luci-app-$OWRT_THEME-config=y" >> .config

#根据源码来修改 ，增加luci界面和luci中文包
if [[ $OWRT_URL != *"lede"* ]] ; then
  echo "CONFIG_PACKAGE_luci=y" >> .config
  echo "CONFIG_LUCI_LANG_zh_Hans=y" >> .config
fi

#删除MT7621MTK硬件加速仓库默认软件
if [[ "$OWRT_URL" == "https://github.com/padavanonly/immortalwrt.git" ]]; then
  echo "CONFIG_PACKAGE_zram-swap=n" >> .config
  echo "CONFIG_PACKAGE_miniupnpd=n" >> .config
  echo "CONFIG_PACKAGE_luci-app-upnp=n" >> .config
  echo "CONFIG_PACKAGE_qos-scripts=n" >> .config
  echo "CONFIG_PACKAGE_luci-app-eqos-mtk=n" >> .config
  echo "CONFIG_PACKAGE_luci-app-mwan3helper-chinaroute=n" >> .config
fi
