networks:
  mngt:
    ip4:
      network: 10.0.0.0
      netmask: 24
      gateway: 10.0.0.1
      dynamic: [10.0.0.128, 10.0.0.253]
    ip6:
      network: '2001:4dd0:ae46:1::'
      netmask: 64
      gateway: '2001:4dd0:ae46:1::1'
  priv:
    ip4:
      network: 10.0.23.0
      netmask: 24
      gateway: 10.0.23.1
      dynamic: [10.0.23.128, 10.0.23.253]
    ip6:
      network: '2001:4dd0:ae46:23::'
      netmask: 64
      gateway: '2001:4dd0:ae46:23::1'
  open:
    ip4:
      network: 10.0.42.0
      netmask: 24
      gateway: 10.0.42.1
      dynamic: [10.0.42.128, 10.0.42.253]
    ip6:
      network: '2001:4dd0:ae46:42::'
      netmask: 64
      gateway: '2001:4dd0:ae46:42::1'

addresses:
  router:
    int:
      mngt:
        mac: 00:0d:b9:34:db:e4
        ip4: 10.0.0.1
        ip6: 2001:4dd0:ae46:0::1
      priv:
        mac: 00:0d:b9:34:db:e4
        ip4: 10.0.23.1
        ip6: 2001:4dd0:ae46:23::1
      open:
        mac: 00:0d:b9:34:db:e4
        ip4: 10.0.42.1
        ip6: 2001:4dd0:ae46:42::1
  modem:
    int:
      mngt:
        mac: 00:1d:aa:87:58:ac
        ip4: 10.0.0.2
        ip6: 2001:4dd0:ae46:1::2
  phone:
    int:
      mngt:
        mac: 00:e1:6d:b8:3c:53
        ip4: 10.0.0.3
        ip6: 2001:4dd0:ae46:1::3
  br1:
    int:
      mngt:
        mac: 58:0a:20:9a:11:72
        ip4: 10.0.0.16
        ip6: 2001:4dd0:ae46:1::10
  br2:
    int:
      mngt:
        mac: 08:cc:68:43:35:a2
        ip4: 10.0.0.17
        ip6: 2001:4dd0:ae46:1::11
  br3:
    int:
      mngt:
        mac: 64:d8:14:5e:c4:81
        ip4: 10.0.0.18
        ip6: 2001:4dd0:ae46:1::12
  ap1:
    int:
      mngt:
        mac: 04:18:d6:80:2d:b7
        ip4: 10.0.0.32
        ip6: 2001:4dd0:ae46:1::20
  ap2:
    int:
      mngt:
        mac: 04:18:d6:80:2c:ff
        ip4: 10.0.0.33
        ip6: 2001:4dd0:ae46:1::21
  nas:
    int:
      mngt:
        mac: 00:d0:b8:1e:cd:00
        ip4: 10.0.0.64
        ip6: 2001:4dd0:ae46:1::40
      priv:
        mac: 00:d0:b8:1e:cd:00
        ip4: 10.0.23.64
        ip6: 2001:4dd0:ae46:2::40
  ps4:
    int:
      priv:
        mac: 00:d9:d1:09:19:fb
        ip4: 10.0.23.65
        ip6: 2001:4dd0:ae46:2::41
  foopi:
    int:
      priv:
        mac: b8:27:eb:1c:32:39
        ip4: 10.0.23.66
        ip6: 2001:4dd0:ae46:2::42
  cinema:
    int:
      mngt:
        mac: 7e:ac:2c:53:1f:03
        ip4: 10.0.0.67
        ip6: 2001:4dd0:ae46:1::43
      priv:
        mac: 00:05:cd:38:94:8a
        ip4: 10.0.23.67
        ip6: 2001:4dd0:ae46:2::43
  mobile:
    int:
      priv:
        mac: 68:f7:28:b4:43:61
        ip4: 10.0.23.127
        ip6: 2001:4dd0:ae46:2::7f
  brueckenkopf:
    int:
      mngt:
        mac: 00:50:56:b3:4b:d0
        ip4: 10.0.0.254
        ip6: 2001:4dd0:ae46:1::fe
    ext:
      hostname: brueckenkopf.dev.open-desk.net
      ip4:
        address: 193.174.29.6
        netmask: 27
        gateway: 193.174.29.1
  bunker:
    int:
      mngt:
        mac: ~
        ip4: 10.0.0.94
        ip6: 2001:4dd0:ae46:1::5e
    ext:
      hostname: bunker.dev.open-desk.net
      ip4:
        address: 37.120.161.15
        netmask: 22
        gateway: 37.120.160.1
  north-zitadelle:
    int:
      mngt:
        mac: ~
        ip4: 10.0.0.95
        ip6: 2001:4dd0:ae46:1::5f
    ext:
      hostname: north.zitadelle.dev.open-desk.net
      ip4:
        address: 37.120.172.185
        netmask: 22
        gateway: 37.120.172.1
  south-zitadelle:
    int:
      mngt:
        mac: ~
        ip4: 10.0.0.96
        ip6: 2001:4dd0:ae46:1::60
    ext:
      hostname: south.zitadelle.dev.open-desk.net
      ip4:
        address: 37.120.172.177
        netmask: 22
        gateway: 37.120.172.1

domain:
  name: open-desk.net
  servers:
    - 78.47.34.12
    - 5.9.49.12
    - 2a01:4f8:192:2393::f023:90af
    - 2a01:6f0:ffff:42::53

