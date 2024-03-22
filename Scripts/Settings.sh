#!/bin/bash

if [[ "$OWRT_TARGET" == "Redmi-AX6" && "$OWRT_URL" == *"NSS"* ]]; then
  
  #删除openwrt官方luci-base和luci-mod-status
  rm -rf feeds/luci/modules/luci-base
  rm -rf feeds/luci/modules/luci-mod-status
  
  #把immortalwrt luci-base和luci-mod-status拷回去
  git clone https://github.com/immortalwrt/luci.git immortalwr_luci
  cp -rf immortalwr_luci/modules/luci-base feeds/luci/modules/
  cp -rf immortalwr_luci/modules/luci-mod-status feeds/luci/modules/
  rm -rf immortalwr_luci

  #删除mhz
  rm -rf feeds/nss-packages/utils/mhz
  
  #删除作者库自定义插件
  rm -rf $(find ./package/new/ -type d -regex ".*\(openclash\|argon\|vlmcsd\|cpufreq\|coremark\|v2ray\).*")

  #添加hello world
  git clone --depth=1 https://github.com/fw876/helloworld.git package/new/helloworld

  #添加lede库luci插件
  git clone https://github.com/coolsnowwolf/luci.git lede_luci
  cp -rf lede_luci/applications/luci-app-accesscontrol package/new/
  cp -rf lede_luci/applications/luci-app-autoreboot package/new/
  cp -rf lede_luci/applications/luci-app-zerotier package/new/
  cp -rf lede_luci/applications/luci-app-filetransfer package/new/
  
  删除lede库
  rm -rf lede_luci
  
  #删除作者config文件对应配置
  sed -i '/cpufreq/d' AX6.config
  sed -i '/argon-config/d' AX6.config
  sed -i '/openclash/d' AX6.config
  sed -i '/vlmcsd/d' AX6.config
  sed -i '/theme-bootstrap/d' AX6.config
  sed -i '/ddns/d' AX6.config
  sed -i '/coremark/d' AX6.config
  sed -i '/COREMARK/d' AX6.config
  sed -i '/theme-argon/d' AX6.config
  sed -i '/mosdns/d' AX6.config

else

  #如果引入smpackage库，则删除冲突插件和argon主题
  rm -rf $(find ./feeds/smpackage/ -type d -regex ".*\(argon\|openclash\).*")
  
fi

if [[ "$OWRT_TARGET" == "Redmi-AX6" && "$OWRT_URL" == *"lede"* ]]; then
  #修复SSR-Plus shadowsocksr-libev libopenssl-legacy 依赖错误问题。
  #因已回退插件库，不需要修复。
  #sed -i 's/ +libopenssl-legacy//g' feeds/smpackage/shadowsocksr-libev/Makefile
  cho 'Fix SSR-Plus Skip!'
fi

if [[ "$OWRT_URL" == *"lede"* ]]; then
  #small-package推荐删除防止与lede库冲突
  rm -rf feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd-alt,miniupnpd-iptables,wireless-regdb}
fi

#删除官方和第三方仓库argon主题

rm -rf $(find ./feeds/luci/ -type d -regex ".*\(argon\).*")

#修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-$OWRT_THEME/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")
#修改默认IP地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$OWRT_IP/g" ./package/base-files/files/bin/config_generate
#修改默认主机名
sed -i "s/hostname='.*'/hostname='$OWRT_NAME'/g" ./package/base-files/files/bin/config_generate
#修改默认时区
sed -i "s/timezone='.*'/timezone='CST-8'/g" ./package/base-files/files/bin/config_generate
sed -i "/timezone='.*'/a\\\t\t\set system.@system[-1].zonename='Asia/Shanghai'" ./package/base-files/files/bin/config_generate

#根据源码来修改
if [[ $OWRT_URL == *"lede"* ]] ; then
  #修改默认时间格式
  sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S %A")/g' $(find ./package/*/autocore/files/ -type f -name "index.htm")
fi

#./scripts/feeds update -a
#./scripts/feeds install -a
