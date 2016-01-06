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

aiccu.conf:
  file.managed:
    - name: /etc/aiccu.conf
    - source: salt://router/aiccu.conf.tmpl
    - template: jinja
    - makedirs: True

