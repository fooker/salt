snmpd.conf.sys:
  file:
    - managed
    - name: /etc/snmp/snmpd.conf.d/sys.conf
    - source: salt://snmp/sys.conf
    - makedirs: True

