backup.server:
  pkg.installed:
    - name: borg

  user.present:
    - name: backup
    - shell: /bin/bash
    - home: /var/lib/backup
    - system: True
  
backup.server.keys:
  file.managed:
    - name: /var/lib/backup/.ssh/authorized_keys
    - source: salt://backup/server/files/authorized_keys.j2
    - makedirs: True
    - template: jinja
    - owner: backup
    - require:
      - user: backup.server

backup.server.snmpd.conf:
  file.managed:
    - name: /etc/snmp/snmpd.conf.d/backup.conf
    - source: salt://backup/server/files/snmpd.conf
    - makedirs: True

{% for host, _ in salt['mine.get']('*', 'backup.client.key', 'glob') | dictsort() -%}
backup.server.repo.{{ host }}:
  file.directory:
    - name: /mnt/backups/borg/{{ host }}
    - user: backup
    - makedirs: True
{% endfor -%}
