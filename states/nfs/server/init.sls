include:
  - nfs


nfs.server:
  file.directory:
    - name: /etc/exports.d/
    - makedirs: True
    - clean: True
  cmd.run:
    - name: /usr/bin/exportfs -rav
    - onchanges:
      - file: /etc/exports.d/*

nfs.server.service:
  file.managed:
    - name: /etc/conf.d/nfs-server.conf
    - contents: |
        ### This file is managed by saltstack - any changes will be overwritten ###
        NFSD_OPTS="-N 2 -N 3"
  service.running:
    - enable: True
    - name: nfs-server
    - require:
      - pkg: nfs-utils
    - watch:
      - file: /etc/conf.d/nfs-server.conf
