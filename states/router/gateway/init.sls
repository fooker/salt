gateway.ferm:
  file.managed:
    - name: /etc/ferm.d/gateway.conf
    - source: salt://router/gateway/files/ferm.conf.j2
    - template: jinja
    - require_in:
      - file: ferm

gateway.forwarding.ipv4:
  sysctl.present:
    - name: net.ipv4.conf.all.forwarding
    - value: 1
    - config: /etc/sysctl.d/80-gateway.conf

gateway.forwarding.ipv6:
  sysctl.present:
    - name: net.ipv6.conf.all.forwarding
    - value: 1
    - config: /etc/sysctl.d/80-gateway.conf

