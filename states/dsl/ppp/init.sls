dsl.ppp:
  pkg.installed:
    - name: ppp
  file.managed:
    - name: /usr/local/lib/systemd/system/ppp@uplink.service.d/restart.conf
    - contents: |
        [Service]
        Restart=on-failure
        RestartSec=30s
    - makedirs: True
    - require_in:
      - file: systemd.system
  service.running:
    - enable: True
    - name: ppp@uplink
    - require:
      - pkg: ppp
    - watch:
      - file: /etc/ppp/options
      - file: /etc/ppp/peers/uplink
      - file: /usr/local/lib/systemd/system/ppp@uplink.service.d/restart.conf


dsl.ppp.options:
  file.managed:
    - name: /etc/ppp/options
    - source: salt://dsl/ppp/files/ppp.options
    - makedirs: True


dsl.ppp.peer:
  file.managed:
    - name: /etc/ppp/peers/uplink
    - source: salt://dsl/ppp/files/ppp.peer.j2
    - template: jinja
    - makedirs: True


dsl.ppp-redail:
  service.running:
    - enable: True
    - name: ppp-redail@uplink.timer
    - require:
      - file: /usr/local/lib/systemd/system/ppp-redail@.timer
      - file: /usr/local/lib/systemd/system/ppp-redail@.service
    - watch:
      - file: /usr/local/lib/systemd/system/ppp-redail@.timer
      - file: /usr/local/lib/systemd/system/ppp-redail@.service


dsl.ppp-redail.service:
  file.managed:
    - name: /usr/local/lib/systemd/system/ppp-redail@.service
    - source: salt://dsl/ppp/files/ppp-redail@.service
    - makedirs: True
    - require_in:
      - file: systemd.system


dsl.ppp-redail.timer:
  file.managed:
    - name: /usr/local/lib/systemd/system/ppp-redail@.timer
    - source: salt://dsl/ppp/files/ppp-redail@.timer
    - makedirs: True
    - require_in:
      - file: systemd.system
