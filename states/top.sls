base:
  '*':
    - salt.minion

    - common.systemd
    - common.sysctl
    - common.logging
    - common.tools
    - common.pacman

    - network
    - iptables

    - snmpd
    - snmpd.sys
    - snmpd.os
    - snmpd.opennms

    - ssh

    - backup.client

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

  'router':
    - dsl.ppp
    - router.gateway
    - router.dns
    - router.dhcp
    - router.ntp
    - router.vnstat
    - ddclient
    - peering
    - unifi

  '*-zitadelle':
    - hive
    - glusterfs
    - glusterfs.mount
    - dn42.roa
    - peering
    - mariadb
    - web.apps
    - redis
    - mail.dovecot
    - mail.postfix
    - mail.rspamd

  'bunker':
    - hive
    - glusterfs
    - mariadb
    - syncthing
    - redis

  'brueckenkopf':
    - salt.master
    - opennms
    - grafana
    - rdp-proxy
    - weechat
    - aurblobs

  'nas':
    - nas
    - backup.server
    - syncthing
    - deluge
    - nfs/server
    - smb/server

  'blaster':
    - odroid
    - mopidy
    - pulseaudio
    - mosquitto
    - homeassistant
    - pad

  'scanner':
    - scanner
    - syncthing
