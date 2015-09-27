openvpn:
  pkg:
    - installed
    - name: openvpn
  service:
    - running
    - enable: True
    - name: openvpn@home
    - require:
      - pkg: openvpn
    - watch:
      - file: /etc/openvpn/home.conf
      - file: /etc/ssl/private/vpn.svc.open-desk.net/ca.crt
      - file: /etc/ssl/private/vpn.svc.open-desk.net/server.crt
      - file: /etc/ssl/private/vpn.svc.open-desk.net/server.key
      - file: /etc/ssl/private/vpn.svc.open-desk.net/server.dh

openvpn.conf:
  file:
    - managed
    - name: /etc/openvpn/home.conf
    - source: salt://openvpn/openvpn.conf
    - makedirs: True
    - template: jinja

openvpn.ca.cert:
  file:
    - managed
    - name: /etc/ssl/private/vpn.svc.open-desk.net/ca.crt
    - source: http://wiki.cacert.org/SimpleApacheCert?action=AttachFile&do=get&target=CAcert_chain.pem
    - source_hash: sha512=a9badd08388f1405f51241e1b4b9dc4607adcd8a6ef3306686348ed8ef245c4469d2738a46327713905e641f68fcf8ff835f5079a38433bca3b2267de56bc71d
    - makedirs: True

openvpn.server.cert:
  file:
    - managed
    - name: /etc/ssl/private/vpn.svc.open-desk.net/server.crt
    - source: salt://vpn.svc.open-desk.net/server.crt
    - makedirs: True

openvpn.server.key:
  file:
    - managed
    - name: /etc/ssl/private/vpn.svc.open-desk.net/server.key
    - source: salt://vpn.svc.open-desk.net/server.key
    - makedirs: True

openvpn.server.dh:
  file:
    - managed
    - name: /etc/ssl/private/vpn.svc.open-desk.net/server.dh
    - contents: |
        -----BEGIN DH PARAMETERS-----
        MIGHAoGBAPuA4rU6KS2XE14f9cjvFALE7l+sDAaSWWpov/uV4i06aLUL9vhsXUPf
        /ZkANqSL8Wm+gKbzy1eQh1eZCnOvv1ck/q1JjOV2JUMjktCCqZ+cvAgnIJkNQWBa
        coRMv2I0d2AtI0CEnXIBhRlzAyvyGtYBV9K5auVKNpsuLi3oCSVbAgEC
        -----END DH PARAMETERS-----
    - makedirs: True

openvpn.iptables:
  file:
    - managed
    - name: /etc/ferm.d/openvpn.conf
    - source: salt://openvpn/ferm.conf
    - makedirs: True
