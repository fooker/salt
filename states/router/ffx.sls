include:
  - router.dnsmasq
  - iptables

ffx.fastd:
  - pkg:
    - installed
    - name: fastd
  - service:
    - running
    - enable: True
    - name: fastd@ffx
    - require:
      - pkg: fastd
    - watch:
      - file: /etc/fastd/ffx/fastd.conf

ffx.fastd.conf:
  file:
    - managed
    - name: /etc/fastd/ffx/fastd.conf
    - source: salt://router/fastd.ffx.conf
    - makedirs: True

ffx.batman.modules-load:
  file:
    - managed
    - name:  /etc/modules-load.d/batman-adv.conf
    - contents: |
        batman-adv

ffx.dnsmasq:
  file:
    - managed
    - name: /etc/dnsmasq.conf.d/ffx.conf
    - source: salt://router/dnsmasq.ffx.conf
    - makedirs: True

ffx.ferm:
  file:
    - managed
    - name: /etc/ferm.d/ffx.conf
    - source: salt://router/ferm.ffx.conf
    - makedirs: True

