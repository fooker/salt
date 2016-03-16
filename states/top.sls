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
    - mariadb
    - glusterfs

  '*-zitadelle':
    - letsencrypt.httpd
    - web.apache
    - web.memcached
    - web.php
    - web.apps.chez_janine
    - web.apps.open_desk
    - web.apps.wolke

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

