# OpenWRT-CI
云编译OpenWRT固件

fork大佬0xlane/OpenWrt-CI的源码，只改了主题和自定义插件

LEDE源码：
https://github.com/coolsnowwolf/lede

IMMORTALWRT源码：
https://github.com/immortalwrt/immortalwrt

# 固件简要说明：

按需手动编译。

固件信息里的时间为编译开始的时间，方便核对上游源码提交时间。

X64系列，包含X64、X86，内核保持最新。

Redmi-AX6因无线驱动问题，暂时维持源码版本在20230501，内核版本固定5.10。

插件仓库回退到2024.01.18以及2024.01.15

固件内置自用的插件为ssr-plus、 mosdns 、zerotier、accesscontrol、wol、upnp、aliyunweb-dav、ua2f、airconnect。

Docker 组件只内置在 X64 固件中。

默认 IP：192.168.31.1，一般最后一个网卡是 wan 口，其它是 lan 口。

默认主题：Argon

# 目录简要说明：

Depends.txt——环境依赖列表

workflows——自定义CI配置

Scripts——自定义脚本

Config——自定义配置

  -- General.txt 为通用配置文件，用于设定各平台都用得到的插件。

  -- 其它 txt 为各平台主要配置文件，用于设定机型及额外插件。
