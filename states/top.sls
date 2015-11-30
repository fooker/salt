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
    - router.aiccu
    - router.dns
    - router.dhcp
    - router.ntp
    - router.netboot
    - router.vnstat
    - router.ddclient
#    - locums
#    - openvpn

  '* and not router':
    - match: compound
    - common.ntp

  'brueckenkopf':
    - salt.master
    - opennms

#  'bunker':
#    - rsnapshot
