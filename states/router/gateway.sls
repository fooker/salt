gateway.ferm:
  file:
    - managed
    - name: /etc/ferm.d/gateway.conf
    - source: salt://router/ferm.gateway.conf.tmpl
    - makedirs: True
    - template: jinja

gateway.sysctl:
  sysctl:
    - present
    - name: net.ipv4.ip_forward
    - value: 1
    - config: /etc/sysctl.d/gateway.conf
