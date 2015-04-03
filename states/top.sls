base:
  '*':
    - sysctl

    - snmp
    - snmp.sys
    - snmp.os
    - snmp.opennms

    - rsnapshot.target

  'srv.* or home.router':
    - iptables
    - ssh
#    - tinc

  'home.router':
    - router/nat
    - router/dns
    - router/dhcp
    - router/netboot
  
  'srv.bunker':
    - rsnapshot
