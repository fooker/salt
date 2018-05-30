salt-master:
  pkg.installed:
    - name: salt
  service.running:
    - enable: True
    - name: salt-master
    - require:
      - pkg: salt
    - watch:
      - file: /etc/salt/master

salt-master.conf:
  file.managed:
    - name: /etc/salt/master
    - source: salt://salt/master/files/conf.j2
    - makedirs: True
    - template: jinja

salt-master.iptables:
  file.managed:
    - name: /etc/ferm.d/salt-master.conf
    - source: salt://salt/master/files/ferm.conf
    - require_in:
      - file: ferm
