base:
  '*':
    - salt.minion

    - common.sysctl
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
    - router.aiccu
    - router.dns
    - router.dhcp
    - router.radvd
    - router.ntp
    - router.netboot
    - router.vnstat
    - router.ddclient
    - router.freifunk

  'cluster':
    - match: nodegroup
    - cluster/network
    - cluster/storage
    - mariadb

  '*-zitadelle':
    - web.apache
    - web.php
    - web.apps

  'bunker':
    - rsnapshot

  'brueckenkopf':
    - letsencrypt
    - salt.master
    - opennms
    - weechat

  'scanner':
    - scanner

  'cinema':
    - cinema

