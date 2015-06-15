dsl.ppp:
  pkg:
    - installed
    - name: ppp
  service:
    - running
    - enable: True
    - name: ppp@uplink
    - require:
      - pkg: ppp
    - watch:
      - file: /etc/ppp/options
      - file: /etc/ppp/peers/uplink


dsl.ppp.options:
  file:
    - managed
    - name: /etc/ppp/options
    - source: salt://router/dsl.ppp.options
    - makedirs: True

dsl.ppp.peer:
  file:
    - managed
    - name: /etc/ppp/peers/uplink
    - source: salt://router/dsl.ppp.peer.tmpl
    - template: jinja
    - makedirs: True

