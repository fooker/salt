base:
  '*':
    - salt.minion

    - common.systemd
    - common.sysctl
    - common.logging
    - common.tools
    - common.pacman

    - network

    - snmpd
    - snmpd.sys
    - snmpd.os
    - snmpd.opennms

    - ssh

    - rsnapshot.target

  '* and not router':
    - match: compound
    - common.timesyncd

  '* and not *-zitadelle':
    - match: compound
    - common.ssmtp

  'public:True':
    - match: grain
    - tinc
    - mosh

  '* and not nas':
    - match: compound
    - iptables

  'router':
    - dsl.ppp
    - dsl.dhcp6c
    - router.gateway
    - router.dns
    - router.dhcp
#    - router.radvd
    - router.ntp
    - router.vnstat
    - ddclient
    - peering
    - unifi

  '*-zitadelle':
    - hive
    - glusterfs
    - glusterfs.mount
    - dn42.roa
    - peering
    - nfs/client
    - mariadb
    - web.apps

  'bunker':
    - hive
    - glusterfs
    - nfs/server
    - mariadb
    - syncthing

  'brueckenkopf':
    - salt.master
    - opennms
    - grafana
    - rdp-proxy
    - weechat
    - aurblobs

  'nas':
    - rsnapshot.server
    - syncthing
    - deluge

  'blaster':
    - odroid
    - mopidy
    - pulseaudio
    - mosquitto
    - homeassistant
    - pad
