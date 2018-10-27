#!/bin/sh

log() {
	logger -s -t "tg-LuCI Install Script" "$1"
}

log "Backing up uci.so..."
mv /usr/lib/lua/uci.so /usr/lib/lua/uci.so_bak

log "Removing LuCI and dependancies..."
opkg remove --force-depends luci luci-lib-json luci-lib-jsonc luci-lib-nixio luci-mod-rpc libiwinfo-lua libiwinfo libuci-lua rpcd-mod-file rpcd-mod-iwinfo rpcd-mod-rpcsys rpcd uhttpd-mod-lua uhttpd-mod-ubus uhttpd

log "Restoring tch uci.so..."
rm /usr/lib/lua/uci.so
mv /usr/lib/lua/uci.so_bak /usr/lib/lua/uci.so

log "Removing www_luci and config Files..."
rm -R /www_luci
rm /etc/config/rpcd
rm /etc/config/uhttpd

log "Done, LuCI removed!"
