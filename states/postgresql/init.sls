postgresql:
  pkg.installed:
    - name: postgresql
  service.running:
    - enable: True
    - name: postgresql
    - require:
      - pkg: postgresql
      - cmd: postgresql.init

postgresql.init:
  cmd.wait:
    - name: initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'
    - user: postgres
    - creates: /var/lib/postgres/data
    - watch:
      - pkg: postgresql

