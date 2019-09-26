backup.client:
  pkg.installed:
    - name: borg

backup.client.key:
  cmd.run:
    - name: mkdir -pv /var/lib/backup/ && ssh-keygen -t ed25519 -N '' -C backup@{{ grains.id }} -f /var/lib/backup/id_ed25519
    - unless: test -f /var/lib/backup/id_ed25519

backup.client.key.publish:
  cmd.run:
    - name: 'salt-call mine.send "backup.client.key" mine_function=cmd.run "cat /var/lib/backup/id_ed25519.pub" 2>/dev/null'

backup.client.known_hosts:
  file.managed:
    - name: /var/lib/backup/known_hosts
    - contents: '{{ pillar.backup.server.host }} {{ pillar.backup.server.fingerprint }}'

backup.client.repo:
  cmd.run:
    - name: >
        borg init
        --encryption repokey
        --umask 027
        backup@{{ pillar.backup.server.host }}:system
    - runas: root
    - unless: >
        borg list
        backup@{{ pillar.backup.server.host }}:system
    - env:
      - BORG_PASSPHRASE: '{{ pillar.backup.password }}'
      - BORG_RSH: 'ssh -i /var/lib/backup/id_ed25519 -o UserKnownHostsFile=/var/lib/backup/known_hosts'

backup.client.service:
  file.managed:
    - name: /usr/local/lib/systemd/system/backup.service
    - source: salt://backup/client/files/backup.service.j2
    - template: jinja
    - makedirs: True

backup.client.timer:
  file.managed:
    - name: /usr/local/lib/systemd/system/backup.timer
    - source: salt://backup/client/files/backup.timer.j2
    - template: jinja
    - makedirs: True

  service.running:
    - name: backup.timer
    - enable: True
    - require:
      - file: backup.client.timer
      - file: backup.client.service

{% macro dir(name) %}
backup.client.dir.{{ name }}:
  file.accumulated:
    - name: backup.dirs
    - filename: /usr/local/lib/systemd/system/backup.service
    - text: {{ varargs | join(' ') }}
    - require_in:
      - file: backup.client.service
{% endmacro %}

{% macro cmd(name, cmd) %}
backup.client.cmd.{{ name }}:
  file.accumulated:
    - name: backup.cmds
    - filename: /usr/local/lib/systemd/system/backup.service
    - text: {{ cmd }}
    - require_in:
      - file: backup.client.service
{% endmacro %}

{{ dir('defaults', *pillar.backup.dirs) }}
