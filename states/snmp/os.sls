snmpd.conf.os:
  file:
    - managed
    - name: /etc/snmp/snmpd.conf.d/os.conf
    - source: salt://snmp/os.conf
    - makedirs: True

snmpd.extends.os.pacman:
  file:
    - managed
    - name: /etc/snmp/extends/pacman
    - source: salt://snmp/os.extend.pacman
    - makedirs: True
    - mode: 755
