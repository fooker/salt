gateway.ferm:
  file.managed:
    - name: /etc/ferm.d/gateway.conf
    - source: salt://router/ferm.gateway.conf.tmpl
    - makedirs: True
    - template: jinja

gateway.forwarding.ipv4:
  sysctl.present:
    - name: net.ipv4.conf.all.forwarding
    - value: 1
    - config: /etc/sysctl.d/cluster.conf

gateway.forwarding.ipv6:
  sysctl.present:
    - name: net.ipv6.conf.all.forwarding
    - value: 1
    - config: /etc/sysctl.d/cluster.conf

