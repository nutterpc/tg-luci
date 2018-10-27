#!/bin/sh

logger() {
logger -s -t "tg-LuCI Install Script:" "$1"
echo "$1"
}

logger "Adding achitecture..."
cat >> /etc/opkg.conf << EOF
arch all 100
arch brcm63xx 200
arch brcm63xx-tch 300
EOF

logger "Adding chaos_calmer feeds into distfeeds.conf..."
cat > /etc/opkg/distfeeds.conf << EOF
src/gz chaos_calmer http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/base
src/gz luci http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/luci
src/gz management http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/management
src/gz routing http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/routing
src/gz packages http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/packages
src/gz telephony http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/telephony
EOF

logger "Updating opkg..."
opkg update

logger "Downloading recompiled packages..."
curl -Lk https://github.com/nutterpc/tg-luci/tarball/master --output /tmp/tg-luci.tar.gz

logger "Untarring tg-luci.tar.gz..."
mkdir /tmp/tg-luci
tar -xzf /tmp/tg-luci.tar.gz -C /tmp/tg-luci

logger "Backing up tch uci.so..."
mv /usr/lib/lua/uci.so /usr/lib/lua/uci.so_bak

logger "Installing LuCI depends..."
rm /tmp/tg-luci.tar.gz
opkg --force-reinstall --force-overwrite --force-checksum install /tmp/tg-luci/*/*.ipk
rm -rf /tmp/tg-luci

logger "Restoring tch uci.so..."
rm /usr/lib/lua/uci.so
mv /usr/lib/lua/uci.so_bak /usr/lib/lua/uci.so

logger "Installing LuCI..." 
opkg install luci luci-lib-json luci-lib-jsonc luci-lib-nixio luci-mod-rpc

logger "Patching LuCI to load uci_luci.so..."
sed -i 's/require "uci"/require "uci_luci"/g' /usr/lib/lua/luci/model/uci.lua

logger "Moving LuCI www to www_luci..."
mkdir /www_luci
mv /www/cgi-bin /www_luci/
mv /www/luci-static /www_luci/
mv /www/index.html /www_luci/

logger "Changing uhttpd ports to 9080/9443..."
if [ ! $(uci get uhttpd.main.listen_http | grep 9080) ]; then
	uci del_list uhttpd.main.listen_http='0.0.0.0:80'
	uci add_list uhttpd.main.listen_http='0.0.0.0:9080'
	uci del_list uhttpd.main.listen_http='[::]:80'
	uci add_list uhttpd.main.listen_http='[::]:9080'
	uci del_list uhttpd.main.listen_https='0.0.0.0:443'
	uci add_list uhttpd.main.listen_https='0.0.0.0:9443'
	uci del_list uhttpd.main.listen_https='[::]:443'
	uci add_list uhttpd.main.listen_https='[::]:9443'
	uci set uhttpd.main.home='/www_luci'
fi

logger "Committing changes and restarting uhttpd..."
uci commit
/etc/init.d/uhttpd restart
logger "LuCI is now READY!"
