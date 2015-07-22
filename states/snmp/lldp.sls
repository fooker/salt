snmpd.lldpd:
  pkg:
    - installed
    - name: lldpd
  service:
    - running
    - name: lldpd
    - enable: True
    - require:
      - pkg: lldpd
    - watch:
      - file: /etc/systemd/system/lldpd.service.d/snmp.conf

snmpd.lldpd.service:
  file:
    - managed
    - name: /etc/systemd/system/lldpd.service.d/snmp.conf
    - contents: |
        [Service]
        ExecStart=
        ExecStart=/usr/bin/lldpd -x
    - makedirs: True

