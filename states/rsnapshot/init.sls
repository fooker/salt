rsnapshot:
  pkg:
    - installed
    - name: rsnapshot

rsnapshot.conf:
  file:
    - managed
    - name: /etc/rsnapshot.conf
    - source: salt://rsnapshot/rsnapshot.conf.tmpl
    - makedirs: True
    - template: jinja

rsnapshot.d:
  file:
    - directory
    - name: /etc/rsnapshot.d
    - makedirs: True
