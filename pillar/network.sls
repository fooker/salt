networks:
  mngt:
    network: 10.0.0.0
    netmask: 24
    gateway: 10.0.0.1
    dynamic: [10.0.0.128, 10.0.0.253]
  priv:
    network: 10.0.23.0
    netmask: 24
    gateway: 10.0.23.1
    dynamic: [10.0.23.128, 10.0.23.253]
  open:
    network: 10.0.42.0
    netmask: 24
    gateway: 10.0.42.1
    dynamic: [10.0.42.128, 10.0.42.253]

addresses:
  router:
    int:
      ip4:
        mngt:
          mac: 00:0d:b9:34:db:e4
          address: 10.0.0.1
        priv:
          mac: 00:0d:b9:34:db:e4
          address: 10.0.23.1
        open:
          mac: 00:0d:b9:34:db:e4
          address: 10.0.42.1
#    ext:
#      hostname: basis.dev.open-desk.net
  modem:
    int:
      ip4:
        mngt:
          mac: 00:1d:aa:87:58:ac
          address: 10.0.0.2
  phone:
    int:
      ip4:
        mngt:
          mac: 00:e1:6d:b8:3c:53
          address: 10.0.0.3
  br1:
    int:
      ip4:
        mngt:
          mac: 58:0a:20:9a:11:72
          address: 10.0.0.16
  br2:
    int:
      ip4:
        mngt:
          mac: 08:cc:68:43:35:a2
          address: 10.0.0.17
  br3:
    int:
      ip4:
        mngt:
          mac: 64:d8:14:5e:c4:81
          address: 10.0.0.18
  ap1:
    int:
      ip4:
        mngt:
          mac: 18:9c:5d:3f:3c:60
          address: 10.0.0.32
  ap2:
    int:
      ip4:
        mngt:
          mac: 18:9c:5d:3f:82:00
          address: 10.0.0.33
  ap:
    int:
      ip4:
        mngt:
          mac: ~
          address: 10.0.0.63
  nas:
    int:
      ip4:
        mngt:
          mac: 00:d0:b8:1e:cd:00
          address: 10.0.0.64
        priv:
          mac: 00:d0:b8:1e:cd:00
          address: 10.0.23.64
  ps4:
    int:
      ip4:
        priv:
          mac: 10:ae:60:7b:e0:a7
          address: 10.0.23.65
  foopi:
    int:
      ip4:
        priv:
          mac: b8:27:eb:1c:32:39
          address: 10.0.23.66
  cinema:
    int:
      ip4:
        mngt:
          mac: 7e:ac:2c:53:1f:03
          address: 10.0.0.67
        priv:
          mac: 00:05:cd:38:94:8a
          address: 10.0.23.67
  paper:
    int:
      ip4:
        mngt:
          mac: fa:cc:94:3d:a7:81
          address: 10.0.0.68
        priv:
          mac: 12:57:94:84:1f:46
          address: 10.0.23.68
  r4g9:
    int:
      ip4:
        priv:
          mac: 3c:97:0e:16:e2:8b
          address: 10.0.23.127
  brueckenkopf:
    int:
      ip4:
        mngt:
          mac: 00:50:56:b3:4b:d0
          address: 10.0.0.254
    ext:
      hostname: brueckenkopf.dev.open-desk.net
      ip4:
        address: 193.174.29.6
        netmask: 27
        gateway: 193.174.29.1
  bunker:
    int:
      ip4:
        mngt:
          mac: ~
          address: 10.0.0.94
    ext:
      hostname: bunker.dev.open-desk.net
      ip4:
        address: 37.120.161.15
        netmask: 22
        gateway: 37.120.160.1
  north-zitadelle:
    int:
      ip4:
        mngt:
          mac: ~
          address: 10.0.0.95
    ext:
      hostname: north.zitadelle.dev.open-desk.net
      ip4:
        address: 37.120.172.185
        netmask: 22
        gateway: 37.120.172.1
  south-zitadelle:
    int:
      ip4:
        mngt:
          mac: ~
          address: 10.0.0.96
    ext:
      hostname: south.zitadelle.dev.open-desk.net
      ip4:
        address: 37.120.172.177
        netmask: 22
        gateway: 37.120.172.1

domain:
  name: open-desk.net
  servers:
    - 185.16.40.143
    - 87.216.170.85
    - 109.69.8.34
    - 195.34.136.145

