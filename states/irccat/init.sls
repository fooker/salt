irccat:
  file.managed:
    - name: /opt/irccat
    - source: salt://irccat/files/irccat
    - makedirs: True
    - mode: 755

irccat.conf:
  file.managed:
    - name: /etc/irccat.json
    - source: salt://irccat/files/irccat.json.j2
    - makedirs: True
    - template: jinja

irccat.service:
  file.managed:
    - name: /usr/local/systemd/system/irccat.service
    - source: salt://irccat/files/irccat.service
    - makedirs: True
    - require_in:
      - file: systemd.system
  service.running:
    - enable: True
    - name: irccat
    - watch:
      - file: irccat
      - file: irccat.conf
      - file: irccat.service

