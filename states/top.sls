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

    - ssh

    - rsnapshot.target

  'public:True':
    - match: grain
    - iptables
    - tinc

  'router':
    - router.gateway
    - router.dns
    - router.dhcp
#    - router.netboot
    - router.ffx
    - router.vnstat

  'brueckenkopf':
    - salt.master
    - opennms

#  'bunker':
#    - rsnapshot
