base:
  '*':
    - salt.minion

    - common.sysctl
    - common.tools
    - common.root

    - network

    - snmp
    - snmp.sys
    - snmp.os
    - snmp.opennms
#    - snmp.lldp

    - ssh

    - rsnapshot.target

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

  '* and not router':
    - match: compound
    - common.ntp

  '* and not *-zitadelle':
    - match: compound
    - common.ssmtp

  '*-zitadelle':
    - mariadb
    - glusterfs
    - web
    - web.apps.chez_janine

  'bunker':
    - mariadb
    - glusterfs
    - rsnapshot

  'brueckenkopf':
    - salt.master
    - opennms
    - weechat

  'scanner':
    - scanner

  'cinema':
    - cinema

