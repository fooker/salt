addresses:
  brueckenkopf:
    hs:
      ip4:
        address: 192.168.31.93
        netmask: 24
    xx:
      ip4:
        address: 192.168.42.254
        netmask: 24

loophole:
  forwardings:
    windows_rdp:
      iface: hs
      host: 192.168.31.29
      port: 3389
