name: basis.dev.open-desk.net

ip:
  int:
    mngt: 10.0.0.1
    priv: 10.0.23.1
    open: 10.0.42.1

dns:
  hosts:
    router.mngt.base.kufuewg.de          : 10.0.0.1  
    modem.mngt.base.kufuewg.de           : 10.0.0.2  
    br1.mngt.base.kufuewg.de             : 10.0.0.11 
    br2.mngt.base.kufuewg.de             : 10.0.0.12 
    br3.mngt.base.kufuewg.de             : 10.0.0.13 
    ap1.mngt.base.kufuewg.de             : 10.0.0.21 
    ap2.mngt.base.kufuewg.de             : 10.0.0.22 
    zitadelle.srv.mngt.base.kufuewg.de   : 10.0.0.97 
    bunker.srv.mngt.base.kufuewg.de      : 10.0.0.98 
    brueckenkopf.srv.mngt.base.kufuewg.de: 10.0.0.99 

    router.base.kufuewg.de               : 10.0.23.1 
    nas.base.kufuewg.de                  : 10.0.23.2 
    amp.base.kufuewg.de                  : 10.0.23.3 

nat:
  forwardings:
    - proto: (tcp udp)
      dport: 6240
      thost: 10.0.23.2
      tport: 6240
