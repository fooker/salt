include:
  - snmpd

snmpd.conf.opennms:
  file.managed:
    - name: /etc/snmp/snmpd.conf.d/opennms.conf
    - source: salt://snmpd/opennms/files/snmpd.conf.j2
    - template: jinja
    - makedirs: True
