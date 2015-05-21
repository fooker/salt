gateway.ferm:
  file:
    - managed
    - name: /etc/ferm.d/gateway.conf
    - source: salt://router/ferm.gateway.conf.tmpl
    - makedirs: True
    - template: jinja

