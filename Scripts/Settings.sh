#!/bin/bash

#删除冲突插件
rm -rf $(find feeds/luci/ -type d -regex ".*\(argon\|design\|mosdns\|v2ray-geodata\|passwall\|openclash\).*")
rm -rf $(find feeds/packages/ -type d -regex ".*\(argon\|design\|mosdns\|v2ray-geodata\|passwall\|openclash\).*")
rm -rf $(find feeds/imluci/ -type d -regex ".*\(argon\|design\|mosdns\|v2ray-geodata\|passwall\|openclash\).*")
rm -rf $(find feeds/impackages/ -type d -regex ".*\(argon\|design\|mosdns\|v2ray-geodata\|passwall\|openclash\).*")
rm -rf $(find feeds/smpackage/ -type d -regex ".*\(argon\|design\|mosdns\|v2ray-geodata\|passwall\|openclash\).*")
rm -rf $(find feeds/smpackage/ -type d -regex ".*\(base-files\|dnsmasq\|firewall\|fullconenat\|libnftnl\|nftables\|ppp\|opkg\|ucl\|upx\|vsftpd-alt\|miniupnpd-iptables\|wireless-regdb\).*")
  
if [[ "$OWRT_TARGET" == "Redmi-AX6" && "$OWRT_URL" == "https://github.com/coolsnowwolf/lede.git" ]]; then
  
  #修复SSR-Plus shadowsocksr-libev libopenssl-legacy 依赖错误问题。
  #因已回退插件库，不需要修复。
  #sed -i 's/ +libopenssl-legacy//g' ./feeds/smpackage/shadowsocksr-libev/Makefile
  echo 'skip'
  
fi

if [[ "$OWRT_URL" == "https://github.com/DoveKi/immortalwrt-nss.git" ]]; then
  
  #添加nss占用信息显示
  #rm -rf feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
  #rm -rf feeds/luci/modules/luci-mod-status/root/usr/share/rpcd/acl.d/luci-mod-status.json
  #cp -rf $GITHUB_WORKSPACE/general/AX6/nss-status/immortal/10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/
  #cp -rf $GITHUB_WORKSPACE/general/AX6/nss-status/immortal/luci-mod-status.json feeds/luci/modules/luci-mod-status/root/usr/share/rpcd/acl.d/
  echo 'skip'
fi

if [[ "$OWRT_URL" == "https://github.com/TerryLip/AX6NSS.git" ]]; then

  #添加CPU,温度，以及nss占用信息显示
  #rm -rf feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
  #rm -rf feeds/luci/modules/luci-mod-status/root/usr/share/rpcd/acl.d/luci-mod-status.json
  #rm -rf feeds/luci/modules/luci-base/root/usr/share/rpcd/ucode/luci
  #cp -rf $GITHUB_WORKSPACE/general/AX6/nss-status/immortal/10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/
  #cp -rf $GITHUB_WORKSPACE/general/AX6/nss-status/immortal/luci-mod-status.json feeds/luci/modules/luci-mod-status/root/usr/share/rpcd/acl.d/
  #cp -rf $GITHUB_WORKSPACE/general/AX6/nss-status/luci_file_from_immortal/luci feeds/luci/modules/luci-base/root/usr/share/rpcd/ucode/
  echo 'skip'

  #移除作者插件
  rm -rf package/new
fi

#自定义单独下载仓库插件函数
function git_sparse_package(){
    # 参数1是分支名,参数2是库地址。所有文件下载到owrt/package/Add_package
    # 同一个仓库下载多个文件夹直接在后面跟文件名或路径，空格分开。
    trap 'rm -rf "$tmpdir"' EXIT
    branch="$1" curl="$2" && shift 2
    rootdir="$PWD"
    localdir=package/Add_package
    [ -d "$localdir" ] || mkdir -p "$localdir"
    tmpdir="$(mktemp -d)" || exit 1
    git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$curl" "$tmpdir"
    cd "$tmpdir"
    git sparse-checkout init --cone
    git sparse-checkout set "$@"
    mv -f "$@" "$rootdir"/"$localdir" && cd "$rootdir"
}

#添加immortal对应插件

if [[ "$OWRT_TARGET" == *"Redmi-AX6-stock"* && "$OWRT_URL" == "https://github.com/TerryLip/AX6NSS.git" ]]; then
  
  #git_sparse_package master https://github.com/immortalwrt/luci applications/luci-app-zerotier
  echo ‘skip’
  
fi

if [[ "$OWRT_TARGET" == *"CR6608"* && "$OWRT_URL" == "https://github.com/padavanonly/immortalwrt.git" ]]; then
  
  #git_sparse_package master https://github.com/immortalwrt/luci applications/luci-app-zerotier
  #git_sparse_package master https://github.com/immortalwrt/packages net/zerotier
  echo ‘skip’
  #rm -rf $(find feeds/luci/applications -type d -regex ".*\(luci-app-zerotier\).*")
  #rm -rf $(find feeds/packages/net/ -type d -regex ".*\(zerotier\).*")
  #mv package/Add_package/zerotier feeds/packages/net/
  #mv package/Add_package/luci-app-zerotier feeds/luci/applications
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
