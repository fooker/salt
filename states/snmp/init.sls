snmpd:
  pkg.installed:
    - name: net-snmp
  service.running:
    - enable: True
    - name: snmpd
    - require:
      - pkg: net-snmp
    - watch:
      - file: /etc/snmp/snmpd.conf
      - file: /etc/snmp/snmpd.conf.d/*

snmpd.conf:
  file.managed:
    - name: /etc/snmp/snmpd.conf
    - source: salt://snmp/snmpd.conf.tmpl
    - makedirs: True
    - template: jinja

