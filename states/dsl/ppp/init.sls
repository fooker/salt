dsl.ppp:
  pkg.installed:
    - name: ppp
  file.managed:
    - name: /usr/local/lib/systemd/system/ppp@uplink.service.d/restart.conf
    - contents: |
        [Unit]
        After=systemd-networkd.service
        PartOf=systemd-networkd.service

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


dsl.network:
  file.managed:
    - name: /etc/systemd/network/50-uplink.network
    - source: salt://dsl/ppp/files/ppp.network
    - makedirs: True
    - require_in:
      - file: network

{% for iface in pillar.addresses[grains.id].int %}
dsl.network.{{iface}}.extend:
  file.managed:
    - name: /etc/systemd/network/60-int.{{iface}}.network.d/ppp.conf
    - source: salt://dsl/ppp/files/ppp.network.extend
    - makedirs: True
    - require_in:
      - file: network
{% endfor %}
