irccat:
  file.managed:
    - name: /opt/irccat
    - source: salt://irccat/irccat
    - makedirs: True
    - mode: 755

irccat.conf:
  file.managed:
    - name: /etc/irccat.json
    - source: salt://irccat/irccat.json.tmpl
    - makedirs: True
    - template: jinja

irccat.service:
  file.managed:
    - name: /etc/systemd/system/irccat.service
    - source: salt://irccat/irccat.service
    - makedirs: True
  service.running:
    - enable: True
    - name: irccat
    - watch:
      - file: /etc/irccat.json
      - file: /opt/irccat
      - file: /etc/systemd/system/irccat.service
