#!/bin/bash

#SSR-Plus
#修复 shadowsocksr-libev libopenssl-legacy 依赖问题。
#因已回退插件库，不需要修复。
#sed -i 's/ +libopenssl-legacy//g' feeds/smpackage/shadowsocksr-libev/Makefile

#passawall
#编译新版Sing-box和hysteria，需golang版本1.20或者以上版本
#lede仓库已是1.20以上版本
#rm -rf feeds/packages/lang/golang
#git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

#不知道哪里来的阿里云盘？
#rm -rf package/feeds/packages/aliyundrive-webdav

#删除冲突插件
rm -rf $(find ./feeds/luci/ -type d -regex ".*\(argon\|design\).*")
rm -rf $(find ./feeds/packages/ -type d -regex ".*\(argon\|design\).*")
rm -rf $(find ./feeds/smpackage/ -type d -regex ".*\(argon\|design\|openclash\).*")

#small-package推荐删除防止与lede库冲突
rm -rf feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd-alt,miniupnpd-iptables,wireless-regdb}

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
