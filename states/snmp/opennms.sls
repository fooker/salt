snmpd.conf.opennms:
  file:
    - managed
    - name: /etc/snmp/snmpd.conf.d/opennms.conf
    - source: salt://snmp/opennms.conf
    - makedirs: True
