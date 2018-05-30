{% import 'rsnapshot/target/init.sls' as rsnapshot %}


include:
  - nfs


nfs.service.exports:
  file.managed:
    - name: /etc/exports.d/data.exports
    - source: salt://nfs/server/files/exports.j2
    - makedirs: True
    - template: jinja
  cmd.wait:
    - name: /usr/bin/exportfs -rav
    - watch:
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


{{ rsnapshot.target('data', '/srv/data') }}

