base:
  '*':
    - salt.minion

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
    - dsl
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
    - grafana
    - irccat
    - weechat

  'nas':
    - rsnapshot.server
    - syncthing

  'blaster':
    - mopidy
    - pulseaudio
