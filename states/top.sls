base:
  '*':
    - salt.minion

    - common.sysctl
    - common.logging
    - common.tools
    - common.root
    - common.pacman

    - network

    - snmp
    - snmp.sys
    - snmp.os
    - snmp.opennms
#    - snmp.lldp

    - ssh

    - rsnapshot.target

  '* and not router':
    - match: compound
    - common.ntp

  '* and not *-zitadelle':
    - match: compound
    - common.ssmtp

  'public:True':
    - match: grain
    - iptables
    - tinc
    - mosh

  'router':
    - router.gateway
    - router.dsl
    - router.dns
    - router.dhcp
    - router.radvd
    - router.ntp
    - router.netboot
    - router.vnstat
    - router.ddclient
    - router.freifunk
    - peering
    - unifi

  '*-zitadelle':
    - hive
    - peering
    - nfs/client
    - mariadb
    - web.apps

  'bunker':
    - hive
    - nfs/server
    - mariadb
    - syncthing

  'brueckenkopf':
    - letsencrypt
    - salt.master
    - opennms
    - irccat
    - weechat

  'nas':
    - rsnapshot
    - syncthing

  'scanner':
    - scanner

  'cinema':
    - cinema

