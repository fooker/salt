{% import 'rsnapshot/target/init.sls' as rsnapshot %}

{% for volume in pillar.hive.volumes %}
{%- set mountpoint = pillar.hive.volumes[volume].mountpoint %}
{%- set unit_name = salt['cmd.run']('systemd-escape -p --suffix=mount ' + mountpoint)  %}

glusterfs.mount.{{ volume }}:
  file.managed:
    - name: /usr/local/lib/systemd/system/{{ unit_name }}
    - source: salt://glusterfs/files/mount.j2
    - mkdirs: True
    - template: jinja
    - context:
      volume: {{ volume }}
  service.running:
    - name: {{ unit_name }}
    - enable: True
    - watch:
      - file: glusterfs.mount.{{ volume }}

{{ rsnapshot.target('data-' + volume, mountpoint) }}
{% endfor %}
