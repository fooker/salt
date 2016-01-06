salt-minion.gnupg:
  pkg.installed:
    - sources:
      - python2-gnupg: salt://salt/python2-gnupg-0.3.7-1-any.pkg.tar.xz

salt-minion:
  pkg.installed:
    - name: salt-zmq
  service.running:
    - enable: True
    - name: salt-minion
    - require:
      - pkg: salt-zmq
