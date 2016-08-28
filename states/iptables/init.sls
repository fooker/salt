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
      - file: /etc/ferm.d/*
  file.directory:
    - name: /etc/ferm.d
    - makedirs: True
    - clean: True

ferm.conf:
  file.managed:
    - name: /etc/ferm.conf
    - source: salt://iptables/ferm.conf
    - makedirs: True

