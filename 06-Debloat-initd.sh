#!/bin/sh
###################################
# ntpd: disable network time server
###################################

uci set system.ntp.enable_server='0'
uci commit

uci set samba.samba.enabled='0'

#############################
# Disable Telephony via MMPBX
#############################

uci set cwmpd.cwmpd_config.state=0
uci set cwmpd.cwmpd_config.upgradesmanaged=0
uci set cwmpd.cwmpd_config.periodicinform_enable=0
uci set cwmpd.cwmpd_config.acs_pass='0'
uci set cwmpd.cwmpd_config.acs_user='0'
uci set cwmpd.cwmpd_config.acs_url='invalid'
uci commit

uci set hotspotd.main.ipv4=0
uci set hotspotd.main.enable=false
uci set hotspotd.main.deploy=false
uci set hotspotd.TLS2G.enable=0
uci set hotspotd.FON2G.enable=0
uci commit

uci set wifi_doctor_agent.config.enabled=0
uci set wifi_doctor_agent.config.cs_url='http://localhost'
uci set wifi_doctor_agent.as_config.url='http://locahost'
uci commit

uci set ltedoctor.logger.enabled=0
uci commit

uci set upnpd.config.enable_natpmp='0'
uci set upnpd.config.enable_upnp='0'
uci set minitr064d.config.enable_upnp='0'
uci commit

uci commit

uci set mobiled.globals.enabled='0'
uci set mobiled.device_defaults.enabled='0'
uci commit

uci set tod.global.enabled='0'
uci set wol.config.enabled='0'
uci commit

cat >> /etc/opkg.conf << EOF
arch all 100
arch brcm63xx 200
arch brcm63xx-tch 300
EOF

# Enable Dropbear
uci set dropbear.lan.enable='1'
uci set dropbear.lan.PasswordAuth=on
uci set dropbear.lan.RootPasswordAuth=on
uci commit
/etc/init.d/dropbear start
/etc/init.d/dropbear enable

# Remove SSH key backdoor that gets shipped by default O_O
echo > /etc/dropbear/authorized_keys

# Disable DHCP for backdoor networks
uci set dhcp.hotspot.disabled='1'
uci set dhcp.fonopen.disabled='1'
uci commit

uci del_list system.ntp.server=chronos.ntp.telstra.net
uci del_list system.ntp.server=chronos1.ntp.telstra.net
uci commit
/etc/init.d/sysntpd stop
/etc/init.d/sysntpd disable

/etc/init.d/wol stop
/etc/init.d/wol disable
/etc/init.d/wansensing stop
/etc/init.d/wansensing disable
/etc/init.d/tod stop
/etc/init.d/tod disable
/etc/init.d/samba stop
/etc/init.d/samba disable
/etc/init.d/samba-nmbd stop
/etc/init.d/samba-nmbd disable
/etc/init.d/pre-mwan stop
/etc/init.d/pre-mwan disable
/etc/init.d/pppoe-relay stop
/etc/init.d/pppoe-relay disable
/etc/init.d/mwan stop
/etc/init.d/mwan disable
/etc/init.d/mobiled stop
/etc/init.d/mobiled disable
/etc/init.d/miniupnpd-tch stop
/etc/init.d/miniupnpd-tch disable
/etc/init.d/minitr064d stop
/etc/init.d/minitr064d disable
/etc/init.d/minidlna stop
/etc/init.d/minidlna disable
/etc/init.d/minidlna-procd stop
/etc/init.d/minidlna-procd disable
/etc/init.d/lte-doctor-logger stop
/etc/init.d/lte-doctor-logger disable
/etc/init.d/iqos stop
/etc/init.d/iqos disable
/etc/init.d/ddns stop
/etc/init.d/ddns disable
/etc/init.d/cupsd stop
/etc/init.d/cupsd disable

# ledfw controls internet/wifi/voip/etc LEDs
/etc/init.d/ledfw stop

uci set button.wifi_onoff.handler='toggleleds.sh'
uci commit

cat > /etc/config/network << EOF
EOF

cat > /etc/config/network << EOF
config interface 'loopback'
        option ifname 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

config interface 'lan'
        option ifname 'eth0 eth1 eth2 eth3 eth4'
        option type 'bridge'
        option proto 'static'
        option netmask '255.255.255.0'
 ##       option ipaddr '0.0.0.0'
 ##       option dns '0.0.0.0'
 ##       option gateway '0.0.0.0'

config switch 'bcmsw'
        option reset '1'
        option enable_vlan '0'
        option qosimppauseenable '0'

config config 'config'
EOF

cat > /etc/sysctl.conf << EOF
EOF

cat > /etc/sysctl.conf << EOF

kernel.panic=3
kernel.core_pattern=|/sbin/core-handler %e.%p.%s.%t.core %p

kernel.printk = 4 4 1 7
kkernel.panic = 10
kernel.sysrq = 0
kernel.shmmax = 4294967296
kernel.shmall = 4194304
kernel.core_uses_pid = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
vm.swappiness = 20
vm.dirty_ratio = 80
vm.dirty_background_ratio = 5
fs.file-max = 2097152
net.core.netdev_max_backlog = 262144
net.core.rmem_default = 31457280
net.core.rmem_max = 67108864
net.core.wmem_default = 31457280
net.core.wmem_max = 67108864
net.core.somaxconn = 65535
net.core.optmem_max = 25165824
net.ipv4.neigh.default.gc_thresh1 = 4096
net.ipv4.neigh.default.gc_thresh2 = 8192
net.ipv4.neigh.default.gc_thresh3 = 16384
net.ipv4.neigh.default.gc_interval = 5
net.ipv4.neigh.default.gc_stale_time = 120
net.netfilter.nf_conntrack_max = 10000000
net.netfilter.nf_conntrack_tcp_loose = 0
net.netfilter.nf_conntrack_tcp_timeout_established = 1800
net.netfilter.nf_conntrack_tcp_timeout_close = 10
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 10
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 20
net.netfilter.nf_conntrack_tcp_timeout_last_ack = 20
net.netfilter.nf_conntrack_tcp_timeout_syn_recv = 20
net.netfilter.nf_conntrack_tcp_timeout_syn_sent = 20
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 10
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.ip_no_pmtu_disc = 1
net.ipv4.route.flush = 1
net.ipv4.route.max_size = 8048576
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.tcp_mem = 65536 131072 262144
net.ipv4.udp_mem = 65536 131072 262144
net.ipv4.tcp_rmem = 4096 87380 33554432
net.ipv4.udp_rmem_min = 16384
net.ipv4.tcp_wmem = 4096 87380 33554432
net.ipv4.udp_wmem_min = 16384
net.ipv4.tcp_max_tw_buckets = 1440000
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_max_orphans = 400000
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_ecn = 2
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 60
net.ipv4.tcp_keepalive_probes = 10
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.ip_forward = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.rp_filter = 1
EOF

sysctl -p

cat > /etc/opkg/distfeeds.conf << EOF
EOF

cat > /etc/opkg/distfeeds.conf << EOF
src/gz chaos_calmer http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/base
src/gz luci http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/luci
src/gz management http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/management
src/gz routing http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/routing
src/gz packages http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/packages
src/gz telephony http://archive.openwrt.org/chaos_calmer/15.05.1/brcm63xx/smp/packages/telephony
EOF

cat > /etc/config/wireless << EOF
EOF

cat > /etc/config/wireless << EOF
config wifi-device 'radio_2G'
	option type 'broadcom'
	option country 'AU'
	option state '1'
	option rateset '1(b) 2(b) 5.5(b) 6(b) 9 11(b) 12(b) 18 24(b) 36 48 54'
	option ht_security_restriction '1'
	option sgi '0'
	option cdd '0'
	option frame_bursting '1'
	option interference_mode 'auto'
	option interference_channel_list '1 2 3 4 5 6 7 8 9 10 11 12 13'
	option acs_config_file '/etc/wireless_acs.conf'
	option channel 'auto'
	option standard 'n'
	option acs_state 'selecting'
	option acs_rescan_period '39901'
	option acs_trace_level '0'
	option acs_chanim_tracing '0'
	option acs_traffic_tracing '0'
	option acs_policy '2'
	option acs_tx_traffic_threshold '100'
	option acs_rx_traffic_threshold '100'
	option acs_traffic_sense_period '10'
	option acs_interference_span '2'
	option acs_channel_monitor_period '5'
	option tx_power_adjust '0'
	option tx_power_overrule_reg '1'
	option stbc '0'
	option channelwidth '40MHz'
	option disabled '0'
	option wmm '1'

config wifi-iface 'wl0'
	option device 'radio_2G'
	option mode 'ap'
	option state '1'
	option network 'lan'
	option reliable_multicast '0'
##	option ssid ''

config wifi-ap 'ap0'
	option iface 'wl0'
	option state '1'
	option public '1'
	option ap_isolation '0'
	option station_history '1'
	option max_assoc '0'
	option pmksa_cache '1'
	option wps_w7pbc '1'
	option wsc_state 'configured'
	option wps_ap_setup_locked '1'
	option wps_credentialformat 'passphrase'
	option acl_mode 'unlock'
	option acl_registration_time '60'
	option trace_modules ' '
	option trace_level 'some'
	option security_mode 'wpa2-psk'
	option pmf 'disabled'
	option wps_state '0'
##	option wpa_psk_key ''
	option bandsteer_id 'bs0'

config wifi-device 'radio_5G'
	option type 'broadcom'
	option country 'AU'
	option channel 'auto'
	option channelwidth '80MHz'
	option standard 'anac'
	option state '1'
	option ht_security_restriction '1'
	option sgi '1'
	option cdd '1'
	option ldpc '1'
	option txbf '1'
	option frame_bursting '1'
	option interference_mode 'auto'
	option acs_config_file '/etc/wireless_acs_5g.conf'
	option acs_state 'selecting'
	option acs_rescan_period '39901'
	option acs_trace_level '0'
	option acs_chanim_tracing '0'
	option acs_traffic_tracing '0'
	option acs_policy '2'
	option acs_rescan_delay '180'
	option acs_rescan_delay_policy 'notraffic'
	option acs_rescan_delay_max_events '60'
	option acs_channel_fail_lockout_period '28800'
	option acs_monitor_action 'policy'
	option acs_tx_traffic_threshold '100'
	option acs_rx_traffic_threshold '100'
	option acs_traffic_sense_period '10'
	option acs_interference_span '2'
	option acs_channel_monitor_period '5'
	option tx_power_adjust '0'
	option tx_power_overrule_reg '1'
	option disabled '0'

config wifi-iface 'wl1'
	option device 'radio_5G'
	option mode 'ap'
	option state '1'
	option network 'lan'
	option reliable_multicast '0'
##	option ssid ''

config wifi-ap 'ap2'
	option iface 'wl1'
	option state '1'
	option public '1'
	option ap_isolation '0'
	option station_history '1'
	option max_assoc '0'
	option security_mode 'wpa2-psk'
	option pmf 'disabled'
	option pmksa_cache '1'
	option wps_w7pbc '1'
	option wsc_state 'configured'
	option wps_credentialformat 'passphrase'
	option wps_ap_setup_locked '1'
	option acl_mode 'unlock'
	option acl_registration_time '60'
	option trace_level 'some'
	option wep_key '23D9D66728'
	option wps_ap_pin '17124188'
##	option wpa_psk_key ''
	option wps_state '0'
	option bandsteer_id 'bs0'

config wifi-bandsteer 'bs0'
	option rssi_threshold '-65'
	option rssi_5g_threshold '-80'
	option policy_mode '5'
	option sta_comeback_to '20'
EOF

cat > /usr/sbin/toggleleds.sh << EOF
#!/bin/sh

ledfw_status=\$(pidof ledfw.lua)

# If currently on
if [ -n "\$ledfw_status" ]; then
  /etc/init.d/ledfw stop
  for led in /sys/class/leds/*; do
    echo '0' > "\$led/brightness"
    echo 'none' > "\$led/trigger"
  done
else
  /etc/init.d/ledfw start

  # Wifi LEDs don't come back on til you restart hostapd
  hostapd_status=\$(pidof hostapd)
  if [ -n "\$hostapd_status" ]; then
    /etc/init.d/hostapd restart
  fi

  sleep 0.5

  # Blue power light
  led="/sys/class/leds/power"
  echo '0' > "\$led:red/brightness"
  echo '255' > "\$led:blue/brightness"
fi
EOF
chmod +x /usr/sbin/toggleleds.sh

cat > /etc/init.d/leds-off << EOF
#!/bin/sh /etc/rc.common

START=99   # Must be after ledfw (12) and led (96)
LEDFW_STATUS=\$(pidof ledfw.lua)

start() {
  if [ -n "\$LEDFW_STATUS" ]; then
    # Toggle off if ledfw is running
    /usr/sbin/toggleleds.sh
  else
    # Explictly turn everything off
    for led in /sys/class/leds/*; do
      echo '0' > "\$led/brightness"
      echo 'none' > "\$led/trigger"
    done
  fi
}
EOF
chmod +x /etc/init.d/leds-off

# Shut all the LEDs down so this takes effect immediately
/etc/init.d/leds-off enable
/etc/init.d/leds-off start

/etc/init.d/intercept stop
/etc/init.d/intercept disable

################################
# Software removal for AP only #
################################

opkg remove nginx --force-removal-of-dependent-packages --force-remove

########################################
# Now this TG799VAC runs as an AP only #
########################################

uci commit
reboot
