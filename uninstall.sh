#!/bin/sh
opkg remove --force-depends luci luci-lib-json luci-lib-jsonc luci-lib-nixio luci-mod-rpc
echo "Removed LuCI"
opkg remove --force-depends libiwinfo-lua libiwinfo libuci-lua rpcd-mod-file rpcd-mod-iwinfo rpcd-mod-rpcsys rpcd
echo "Removed LuCI Dependancies"
opkg remove --force-depends uhttpd-mod-lua uhttpd-mod-ubus uhttpd
echo "Removed LuCI Webserver (uhttpd)"
rm -R /www_luci
echo "Removed LuCI Directory"
rm /etc/config/rpcd
rm /etc/config/uhttpd
echo "Removed Config Files"
echo "Done"
