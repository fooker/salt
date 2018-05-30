rsnapshot.target:
  pkg:
    - installed
    - name: rsync

rsnapshot.target.ssh:
  ssh_auth:
    - present
    - user: root
    - enc: {{ pillar.backup.ssh.key.type }}
    - name: {{ pillar.backup.ssh.key.public }}
    - comment: rsnapshot

rsnapshot.target.conf:
  file.managed:
    - name: /etc/rsnapshot.conf.incl
    - source: salt://rsnapshot/target/files/rsnapshot.conf.incl.j2
    - makedirs: True
    - template: jinja

{% macro target(name) -%}
rsnapshot.target.conf.{{ name }}:
  file.accumulated:
    - name: rsnapshot.backups
    - filename: /etc/rsnapshot.conf.incl
    - text: | {% for path in varargs %}
        backup	root@{{ pillar.addresses[grains.id].int.mngt.ip4 }}:{{ path }}	{{ grains.id }}{% endfor %}
    - require_in:
      - file: rsnapshot.target.conf
{%- endmacro %}

{{ target('default', '/etc/') }}

