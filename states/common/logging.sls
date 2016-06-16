logging.journald:
  file.managed:
    - name: /etc/systemd/journald.conf
    - source: salt://common/journald.conf

