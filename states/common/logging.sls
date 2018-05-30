logging.journald:
  file.managed:
    - name: /etc/systemd/journald.conf
    - source: salt://common/files/journald.conf

