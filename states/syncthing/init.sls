syncthing:
  pkg.installed:
    - name: syncthing
  user.present:
    - name: syncthing
    - home: /var/lib/syncthing
    - createhome: True
    - shell: /bin/nologin
  service.running:
    - enable: True
    - name: syncthing@syncthing
    - require:
      - pkg: syncthing
      - user: syncthing

{% if grains['public'] %}
syncthing.iptables:
  file.managed:
    - name: /etc/ferm.d/syncthing.conf
    - source: salt://syncthing/files/ferm.conf
    - require_in:
      - file: ferm
{% endif %}
