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


#删除冲突插件
rm -rf $(find ./feeds/luci/ -type d -regex ".*\(argon\|design\).*")
rm -rf $(find ./feeds/packages/ -type d -regex ".*\(argon\|design\).*")
rm -rf $(find ./feeds/smpackage/ -type d -regex ".*\(argon\|design\|openclash\).*")

if [[ "$OWRT_TARGET" == "Redmi-AX6" && "$OWRT_URL" == *"NSS"* ]]; then
  #删除冲突插件
  rm -rf feeds/luci/modules/luci-base
  rm -rf feeds/luci/modules/luci-mod-status
  rm -rf feeds/packages/utils/coremark
  rm -rf feeds/packages/net/v2ray-geodata
  rm -rf feeds/nss-packages/utils/mhz
 
  #替换luci-base和luci-mod-status
  git clone https://github.com/immortalwrt/luci.git luci_tmp
  cp -rf ./luci_tmp/modules/luci-base feeds/luci/modules/
  cp -rf ./luci_tmp/modules/luci-mod-status feeds/luci/modules/
  rm -rf ./luci_tmp

  #删除作者库自定义插件
  rm -rf $(find ./package/new/ -type d -regex ".*\(openclash\|argon\|vlmcsd\|cpufreq\|coremark\|v2ray\).*")

  #删除作者config文件对应配置
  sed -i '/cpufreq/d' ./AX6.config
  sed -i '/argon-config/d' ./AX6.config
  sed -i '/openclash/d' ./AX6.config
  sed -i '/vlmcsd/d' ./AX6.config
  sed -i '/theme-bootstrap/d' ./AX6.config
  sed -i '/ddns/d' ./AX6.config
  sed -i '/coremark/d' ./AX6.config
  sed -i '/v2ray/d' ./AX6.config
  sed -i '/theme-argon/d' ./AX6.config
  sed -i '/mosdns/d' ./AX6.config
  
fi

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

rm -rf ./tmp
./scripts/feeds update -a
./scripts/feeds install -a
