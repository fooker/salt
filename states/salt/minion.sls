salt-minion.gnupg:
  pkg.installed:
    - sources:
      - python2-gnupg: salt://salt/python2-gnupg-0.3.7-1-any.pkg.tar.xz

salt-minion:
  pkg.installed:
    - name: salt
  service.running:
    - enable: True
    - name: salt-minion
    - watch:
      - pkg: salt
      - file: /etc/salt/minion.d/*

salt-minion.hash_type:
  file.managed:
    - name: /etc/salt/minion.d/hash_type.conf
    - contents: |
        ### This file is managed by saltstack - any changes will be overwritten ###
        hash_type: sha256

