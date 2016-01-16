aiccu:
  pkg.installed:
    - name: aiccu
  service.running:
    - enable: True
    - name: aiccu
    - require:
      - pkg: aiccu
    - watch:
      - file: /etc/aiccu.conf
      - file: /etc/systemd/system/aiccu.service.d/restart.conf
      - file: /etc/systemd/system/aiccu.service.d/online.conf

aiccu.service.online:
  file.managed:
    - name: /etc/systemd/system/aiccu.service.d/online.conf
    - contents: |
        [Unit]
        Wants=network.target network-online.target
        After=network.target network-online.target
    - makedirs: True

aiccu.service.restart:
  file.managed:
    - name: /etc/systemd/system/aiccu.service.d/restart.conf
    - contents: |
        [Service]
        Restart=on-failure
        RestartSec=30s
    - makedirs: True

aiccu.conf:
  file.managed:
    - name: /etc/aiccu.conf
    - source: salt://router/aiccu.conf.tmpl
    - template: jinja
    - makedirs: True

