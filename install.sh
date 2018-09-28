#!/bin/sh

cat >> /etc/opkg.conf << EOF
arch all 100
arch brcm63xx 200
arch brcm63xx-tch 300
EOF
echo "Changed Architecture"

cat > /etc/opkg/distfeeds.conf << EOF
src/gz chaos_calmer http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/base
src/gz luci http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/luci
src/gz management http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/management
src/gz routing http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/routing
src/gz packages http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/packages
src/gz telephony http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/telephony
EOF
echo "Added appropriate lists into distfeeds.conf"

opkg update
echo "Updated opkg"

curl -Lk https://github.com/nutterpc/tg-luci/tarball/master --output /tmp/tg-luci.tar.gz
echo "Downloaded the .ipk files"
mkdir /tmp/tg-luci
tar -xzf /tmp/tg-luci.tar.gz -C /tmp/tg-luci
echo "Untarred the .ipk files"
rm /tmp/tg-luci.tar.gz
opkg --force-reinstall --force-overwrite --force-checksum install /tmp/tg-luci/*/*.ipk
echo "Installing LuCI dependancies using opkg"
rm -rf /tmp/tg-luci

opkg install luci luci-lib-json luci-lib-jsonc luci-lib-nixio luci-mod-rpc
echo "Installing LuCI"

mkdir /www_luci
mv /www/cgi-bin /www_luci/
mv /www/luci-static /www_luci/
mv /www/index.html /www_luci/
echo "Moving files"

if [ ! $(uci get uhttpd.main.listen_http | grep 9080) ]; then
	uci del_list uhttpd.main.listen_http='0.0.0.0:80'
	uci add_list uhttpd.main.listen_http='0.0.0.0:9080'
	uci del_list uhttpd.main.listen_http='[::]:80'
	uci add_list uhttpd.main.listen_http='[::]:9080'
	uci del_list uhttpd.main.listen_https='0.0.0.0:443'
	uci add_list uhttpd.main.listen_https='0.0.0.0:9443'
	uci del_list uhttpd.main.listen_https='[::]:443'
	uci add_list uhttpd.main.listen_https='[::]:9433'
	uci set uhttpd.main.home='/www_luci'
fi
echo "Changed uhttpd port to 9080"

uci commit
echo "Committed UCI changes"
/etc/init.d/uhttpd restart
echo "Done. Restart your modem now for the changes to take effect"
