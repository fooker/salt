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

  '* and not router':
    - match: compound
    - common.ntp

  '*-zitadelle':
    - mariadb
    - glusterfs
    - web
    - web.apps.chez_janine

  '* and not *-zitadelle':
    - match: compound
    - common.ssmtp

  'brueckenkopf':
    - salt.master
    - opennms

  'bunker':
    - mariadb
    - glusterfs
    - rsnapshot
