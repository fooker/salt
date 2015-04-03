nat.ferm:
  file:
    - managed
    - name: /etc/ferm.d/nat.conf
    - source: salt://router/ferm.nat.conf.tmpl
    - makedirs: True
    - template: jinja

nat.sysctl:
  sysctl:
    - present
    - name: net.ipv4.ip_forward
    - value: 1
    - config: /etc/sysctl.d/nat.conf
