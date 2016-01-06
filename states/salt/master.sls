salt-master:
  pkg.installed:
    - name: salt-zmq
  service.running:
    - enable: True
    - name: salt-master
    - require:
      - pkg: salt-zmq
    - watch:
      - file: /etc/salt/master

salt-master.conf:
  file.managed:
    - name: /etc/salt/master
    - source: salt://salt/master.conf
    - makedirs: True

salt-master.iptables:
  file.managed:
    - name: /etc/ferm.d/salt-master.conf
    - source: salt://salt/master.ferm.conf
    - makedirs: True
