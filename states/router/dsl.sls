dsl.ppp:
  pkg.installed:
    - name: ppp
  file.managed:
    - name: /etc/systemd/system/ppp@uplink.service.d/restart.conf
    - contents: |
        [Service]
        Restart=on-failure
        RestartSec=30s
    - makedirs: True
  service.running:
    - enable: True
    - name: ppp@uplink
    - require:
      - pkg: ppp
    - watch:
      - file: /etc/ppp/options
      - file: /etc/ppp/peers/uplink
      - file: /etc/systemd/system/ppp@uplink.service.d/restart.conf


dsl.ppp.options:
  file.managed:
    - name: /etc/ppp/options
    - source: salt://router/dsl.ppp.options
    - makedirs: True


dsl.ppp.peer:
  file.managed:
    - name: /etc/ppp/peers/uplink
    - source: salt://router/dsl.ppp.peer.tmpl
    - template: jinja
    - makedirs: True


dsl.ppp-redail:
  service.running:
    - enable: True
    - name: ppp-redail@uplink.timer
    - require:
      - file: /etc/systemd/system/ppp-redail@.timer
      - file: /etc/systemd/system/ppp-redail@.service
    - watch:
      - file: /etc/systemd/system/ppp-redail@.timer
      - file: /etc/systemd/system/ppp-redail@.service


dsl.ppp-redail.service:
  file.managed:
    - name: /etc/systemd/system/ppp-redail@.service
    - source: salt://router/dsl.ppp-redail@.service
    - makedirs: True


dsl.ppp-redail.timer:
  file.managed:
    - name: /etc/systemd/system/ppp-redail@.timer
    - source: salt://router/dsl.ppp-redail@.timer
    - makedirs: True
