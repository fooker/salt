salt-minion:
  pkg.installed:
    - pkgs:
      - python2-psutil
      - python2-gnupg
      - salt
  service.running:
    - enable: True
    - name: salt-minion
    - watch:
      - pkg: salt-minion
      - file: /etc/salt/minion.d/*

salt-minion.hash_type:
  file.managed:
    - name: /etc/salt/minion.d/hash_type.conf
    - contents: |
        ### This file is managed by saltstack - any changes will be overwritten ###
        hash_type: sha256

