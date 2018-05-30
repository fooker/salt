include:
  - snmpd

snmpd.conf.sys:
  file.managed:
    - name: /etc/snmp/snmpd.conf.d/sys.conf
    - source: salt://snmpd/sys/files/snmpd.conf
    - makedirs: True

