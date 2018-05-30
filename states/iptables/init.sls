ferm:
  pkg.installed:
    - name: ferm
  service.running:
    - enable: True
    - name: ferm
    - require:
      - pkg: ferm
    - watch:
      - file: /etc/ferm.conf
      - file: /etc/ferm.conf.custom
      - file: /etc/ferm.d/*
  file.directory:
    - name: /etc/ferm.d
    - makedirs: True
    - clean: True

ferm.conf:
  file.managed:
    - name: /etc/ferm.conf
    - source: salt://iptables/files/ferm.conf
    - makedirs: True

ferm.conf.custom:
  file.managed:
    - name: /etc/ferm.conf.custom

