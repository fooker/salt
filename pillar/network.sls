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
      mac: 00:0d:b9:34:db:e4
      ip4:
        mngt:
          address: 10.0.0.1
        priv:
          address: 10.0.23.1
        open:
          address: 10.0.42.1
    ext:
      hostname: basis.dev.open-desk.net
      ip4:
        address: 10.13.37.2
        netmask: 24
        gateway: 10.13.37.1
  br1:
    int:
      mac: 58:0a:20:9a:11:72
      ip4:
        mngt:
          address: 10.0.0.16
  br2:
    int:
      mac: 08:cc:68:43:35:a2
      ip4:
        mngt:
          address: 10.0.0.17
  br3:
    int:
      mac: 64:d8:14:5e:c4:81
      ip4:
        mngt:
          address: 10.0.0.18
  ap1:
    int:
      mac: 18:9c:5d:3f:3c:60
      ip4:
        mngt:
          address: 10.0.0.32
  ap2:
    int:
      mac: 18:9c:5d:3f:82:00
      ip4:
        mngt:
          address: 10.0.0.33
  nas:
    int:
      mac: 00:d0:b8:1e:cd:00
      ip4:
        mngt:
          address: 10.0.0.64
        priv:
          address: 10.0.23.64
  amp:
    int:
      mac: 00:05:cd:38:94:8a
      ip4:
        priv:
          address: 10.0.0.65
  ps4:
    int:
      mac: 10:ae:60:7b:e0:a7
      ip4:
        priv:
          address: 10.0.0.55
  foopi:
    int:
      mac: 3c:97:0e:16:e2:8b
      ip4:
        priv:
          address: 10.0.0.67
  r4g9:
    int:
      mac: 3c:97:0e:16:e2:8b
      ip4:
        priv:
          address: 10.0.0.127
  brueckenkopf:
    int:
      mac: 00:50:56:b3:4b:d0
      ip4:
        mngt:
          address: 10.0.0.254
    ext:
      hostname: brueckenkopf.dev.open-desk.net
      ip4:
        address: 193.174.29.6
        netmask: 27
        gateway: 193.174.29.1
  bunker:
    int:
      mac: ~
      ip4:
        mngt:
          address: 10.0.0.94
    ext:
      hostname: bunker.dev.open-desk.net
      ip4:
        address: 37.120.161.15
        netmask: 22
        gateway: 37.120.160.1
  north-zitadelle:
    int:
      mac: ~
      ip4:
        mngt:
          address: 10.0.0.95
    ext:
      hostname: north.zitadelle.dev.open-desk.net
      ip4:
        address: 37.120.172.185
        netmask: 22
        gateway: 37.120.160.1
  south-zitadelle:
    int:
      mac: ~
      ip4:
        mngt:
          address: 10.0.0.96
    ext:
      hostname: south.zitadelle.dev.open-desk.net
      ip4:
        address: 37.120.172.177
        netmask: 22
        gateway: 37.120.160.1

domain:
  name: open-desk.net

