mosquitto:
  pkg.installed:
    - name: mosquitto
  file.managed:
   - name: /etc/mosquitto.conf
   - source: salt://mosquitto/files/mosquitto.conf
  service.running:
    - name: mosquitto
    - enable: True
    - watch:
      - pkg: mosquitto
      - file: mosquitto

mosquitto.iptables:
  file.managed:
    - name: /etc/ferm.d/mosquitto.conf
    - source: salt://mosquitto/files/ferm.conf
    - require_in:
      - file: ferm
