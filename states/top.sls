base:
  '*':
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
    - router.dns
    - router.dhcp
    - router.ntp
    - router.netboot
#    - router.ffx
    - router.vnstat
    - router.ddclient
    - router.locums

  'brueckenkopf':
    - salt.master
    - opennms

#  'bunker':
#    - rsnapshot
