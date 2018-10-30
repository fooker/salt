networks:
  mngt:
    ip4:
      network: 10.0.0.0
      netmask: 24
      gateway: 10.0.0.1
      dynamic: [10.0.0.128, 10.0.0.253]
    ip6:
      sla: 0
      network: 'fd79:300d:6056:0100::'
      netmask: 64
      gateway: 'fd79:300d:6056:0100::1'
  priv:
    ip4:
      network: 10.0.23.0
      netmask: 24
      gateway: 10.0.23.1
      dynamic: [10.0.23.128, 10.0.23.253]
    ip6:
      sla: 23
      network: 'fd79:300d:6056:0123::'
      netmask: 64
      gateway: 'fd79:300d:6056:0123::1'
  open:
    ip4:
      network: 10.0.42.0
      netmask: 24
      gateway: 10.0.42.1
      dynamic: [10.0.42.128, 10.0.42.253]
    ip6:
      sla: 42
      network: 'fd79:300d:6056:0142::'
      netmask: 64
      gateway: 'fd79:300d:6056:0142::1'
  major:
    ip4:
      network: 10.10.10.0
      netmask: 24
      gateway: 10.10.10.1
      dynamic: [10.10.10.100, 10.10.10.250]
    ip6:
      sla: 64
    #   network: '2001:4dd0:ae46:64::'
    #   netmask: 64
    #   gateway: '2001:4dd0:ae46:64::1'


addresses:
  router:
    int:
      mngt:
        mac: 00:0d:b9:34:db:e4
        ip4: 10.0.0.1
        ip6: fd79:300d:6056:0100::1
      priv:
        mac: 00:0d:b9:34:db:e4
        ip4: 10.0.23.1
        ip6: fd79:300d:6056:0123::1
      open:
        mac: 00:0d:b9:34:db:e4
        ip4: 10.0.42.1
        ip6: fd79:300d:6056:0142::1
      major:
        mac: 00:0d:b9:34:db:e4
        ip4: 10.10.10.1
      #  ip6: 2001:4dd0:ae46:64::1
    ffx:
      data:
        mac: 00:0d:b9:34:db:e4
        ip4: 10.185.1.101
        ip6: fd00:65a8:93a4::1:65
    maglab:
      ip4:
        mac: ~
        ip4: 172.23.172.63
    dn42:
      ip4:
        address: 172.23.200.129
        network: 172.23.200.128
        netmask: 25
      ip6:
        address: fd79:300d:6056:0100::0
        network: fd79:300d:6056:0100::0
        netmask: 56
  modem:
    int:
      mngt:
        mac: 00:1d:aa:87:58:ac
        ip4: 10.0.0.2
        ip6: fd79:300d:6056:0100::2
  phone:
    int:
      mngt:
        mac: 00:e1:6d:b8:3c:53
        ip4: 10.0.0.3
        ip6: fd79:300d:6056:0100::3
  br1:
    int:
      mngt:
        mac: 58:0a:20:9a:11:72
        ip4: 10.0.0.16
        ip6: fd79:300d:6056:0100::a
  br2:
    int:
      mngt:
        mac: 08:cc:68:43:35:a2
        ip4: 10.0.0.17
        ip6: fd79:300d:6056:0100::b
  br3:
    int:
      mngt:
        mac: 9c:57:ad:a0:ad:67
        ip4: 10.0.0.18
        ip6: fd79:300d:6056:0100::c
  ap1:
    int:
      mngt:
        mac: 04:18:d6:80:2d:b7
        ip4: 10.0.0.32
        ip6: fd79:300d:6056:0100::14
  ap2:
    int:
      mngt:
        mac: 04:18:d6:80:2c:ff
        ip4: 10.0.0.33
        ip6: fd79:300d:6056:0100::15
  nas:
    int:
      mngt:
        mac: 00:d0:b8:1e:cd:00
        ip4: 10.0.0.64
        ip6: fd79:300d:6056:0100::28
      priv:
        mac: 00:d0:b8:1e:cd:00
        ip4: 10.0.23.64
        ip6: fd79:300d:6056:0123::28
  ps4:
    int:
      priv:
        mac: 00:d9:d1:09:19:fb
        ip4: 10.0.23.65
        ip6: fd79:300d:6056:0123::29
  blaster:
    aliases:
      - music
      - hass
    int:
      mngt:
        mac: b8:27:eb:cb:20:ed
        ip4: 10.0.0.66
        ip6: fd79:300d:6056:0100::2a
      priv:
        mac: b8:27:eb:cb:20:ed
        ip4: 10.0.23.66
        ip6: fd79:300d:6056:0123::2a
  amp:
    int:
      priv:
        mac: 00:05:cd:38:94:8a
        ip4: 10.0.23.67
        ip6: fd79:300d:6056:0123::2b
  cinema:
    int:
      mngt:
        mac: b8:ae:ed:7d:69:ab
        ip4: 10.0.0.68
        ip6: fd79:300d:6056:0100::2c
      priv:
        mac: b8:ae:ed:7d:69:ab
        ip4: 10.0.23.68
        ip6: fd79:300d:6056:0123::2c
  scanner:
    int:
      mngt:
        mac: 00:08:a2:09:bd:9e
        ip4: 10.0.0.69
        ip6: fd79:300d:6056:0100::2d
      priv:
        mac: 00:08:a2:09:bd:9e
        ip4: 10.0.23.69
        ip6: fd79:300d:6056:0123::2d
  freifunk:
    int:
      open:
        mac: 32:b6:c2:6e:a5:ed
        ip4: 10.0.42.70
        ip6: fd79:300d:6056:0142::2e
  mobile:
    int:
      priv:
        mac: 68:f7:28:b4:43:61
        ip4: 10.0.23.127
        ip6: fd79:300d:6056:0123::ffff
      mngt:
        mac: ~
        ip4: 10.0.0.127
        ip6: fd79:300d:6056:0100::ffff
  brueckenkopf:
    int:
      mngt:
        mac: 00:50:56:b3:4b:d0
        ip4: 10.0.0.254
        ip6: fd79:300d:6056:0100::fe
    ext:
      hostname: brueckenkopf.dev.open-desk.net
      ip4:
        address: 193.174.29.6
        netmask: 27
        gateway: 193.174.29.1
      ip6:
        address: '2001:638:301:11a3::6'
        netmask: 64
        gateway: '2001:638:301:11a3::'
  bunker:
    int:
      mngt:
        mac: ~
        ip4: 10.0.0.94
        ip6: fd79:300d:6056:0100::5e
    ext:
      hostname: bunker.dev.open-desk.net
      ip4:
        address: 37.120.161.15
        netmask: 22
        gateway: 37.120.160.1
      ip6:
        address: 2a03:4000:6:30f2::0
        netmask: 64
        gateway: fe80::1
    hive:
      ip4:
        address: 192.168.33.3
        network: 192.168.33.3
        netmask: 32
      ip6:
        address: fd4c:8f0:aff2::3
        network: fd4c:8f0:aff2::3
        netmask: 128
  north-zitadelle:
    int:
      mngt:
        mac: ~
        ip4: 10.0.0.95
        ip6: fd79:300d:6056:0100::5f
    ext:
      hostname: north.zitadelle.dev.open-desk.net
      ip4:
        address: 37.120.172.185
        netmask: 22
        gateway: 37.120.172.1
      ip6:
        address: 2a03:4000:6:701e::0
        netmask: 64
        gateway: fe80::1
    hive:
      ip4:
        address: 192.168.33.1
        network: 192.168.33.1
        netmask: 32
      ip6:
        address: fd4c:8f0:aff2::1
        network: fd4c:8f0:aff2::1
        netmask: 128
    dn42:
      ip4:
        address: 172.23.200.1
        network: 172.23.200.1
        netmask: 32
      ip6:
        address: fd79:300d:6056::1
        network: fd79:300d:6056::1
        netmask: 128
  south-zitadelle:
    int:
      mngt:
        mac: ~
        ip4: 10.0.0.96
        ip6: fd79:300d:6056:0100::0
    ext:
      hostname: south.zitadelle.dev.open-desk.net
      ip4:
        address: 37.120.172.177
        netmask: 22
        gateway: 37.120.172.1
      ip6:
        address: 2a03:4000:6:701d::0
        netmask: 64
        gateway: fe80::1
    hive:
      ip4:
        address: 192.168.33.2
        network: 192.168.33.2
        netmask: 32
      ip6:
        address: fd4c:8f0:aff2::2
        network: fd4c:8f0:aff2::2
        netmask: 128
    dn42:
      ip4:
        address: 172.23.200.2
        network: 172.23.200.2
        netmask: 32
      ip6:
        address: fd79:300d:6056::2
        network: fd79:300d:6056::2
        netmask: 128

domain:
  name: open-desk.net
  ttl: 3600
