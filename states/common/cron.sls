cron:
  pkg.installed:
    - name: cronie
  service.running:
    - enable: True
    - name: cronie
    - require:
      - pkg: cronie

