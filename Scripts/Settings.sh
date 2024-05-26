#!/bin/bash

#删除官方和第三方仓库argon,design主题,openclash,mosdns
rm -rf $(find ./feeds/luci/ -type d -regex ".*\(argon\|design\|mosdns\|v2ray-geodata\|passwall\|openclash\).*")
rm -rf $(find ./feeds/packages/ -type d -regex ".*\(argon\|design\|mosdns\|v2ray-geodata\|passwall\|openclash\).*")

#如果引入smpackage库，则删除冲突插件和argon主题
#rm -rf $(find ./feeds/smpackage/ -type d -regex ".*\(argon\|design\|mosdns\|v2ray-geodata\|passwall\|openclash\).*")

#small-package推荐删除防止与lede库冲突，immortalwrt应该也是？
#rm -rf ./feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd-alt,miniupnpd-iptables,wireless-regdb}
  

if [[ "$OWRT_TARGET" == "Redmi-AX6" && "$OWRT_URL" == "https://github.com/coolsnowwolf/lede.git" ]]; then
  
  #修复SSR-Plus shadowsocksr-libev libopenssl-legacy 依赖错误问题。
  #因已回退插件库，不需要修复。
  #sed -i 's/ +libopenssl-legacy//g' ./feeds/smpackage/shadowsocksr-libev/Makefile
  echo 'skip'
  
fi

if [[ "$OWRT_URL" == "https://github.com/DoveKi/immortalwrt-nss.git" ]]; then
  
  #添加nss占用信息显示
  rm -rf feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
  rm -rf feeds/luci/modules/luci-mod-status/root/usr/share/rpcd/acl.d/luci-mod-status.json
  cp -rf $GITHUB_WORKSPACE/general/AX6/nss-status/immortal/10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/
  cp -rf $GITHUB_WORKSPACE/general/AX6/nss-status/immortal/luci-mod-status.json feeds/luci/modules/luci-mod-status/root/usr/share/rpcd/acl.d/
  #echo 'skip'
fi


if [[ "$OWRT_URL" == "https://github.com/TerryLip/AX6NSS.git" ]]; then

  #添加nss占用信息显示
  rm -rf feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
  rm -rf feeds/luci/modules/luci-mod-status/root/usr/share/rpcd/acl.d/luci-mod-status.json
  cp -rf $GITHUB_WORKSPACE/general/AX6/nss-status/immortal/10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/
  cp -rf $GITHUB_WORKSPACE/general/AX6/nss-status/immortal/luci-mod-status.json feeds/luci/modules/luci-mod-status/root/usr/share/rpcd/acl.d/
  #echo 'skip'

  #移除作者插件
  rm -rf package/new
fi

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
