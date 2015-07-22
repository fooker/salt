locums:
  pkg:
    - installed
    - name: lxc

{% for locum in pillar['locums'].keys() %}
locums.{{ locum }}:
  service:
    - running
    - name: lxc@{{ locum }}
    - enable: True
    - require:
      - pkg: lxc
    - watch:
      - file: /var/lib/lxc/{{ locum }}/config
      - mount: /var/lib/lxc/{{ locum }}/rootfs

locums.{{ locum }}.lxc.conf:
  file:
    - managed
    - name: /var/lib/lxc/{{ locum }}/config
    - source: salt://router/locums.lxc.conf.tmpl
    - makedirs: True
    - template: jinja
    - context:
      locum: {{ locum }}

locums.{{ locum }}.mount:
  mount:
    - mounted
    - name: /var/lib/lxc/{{ locum }}/rootfs
    - device: nas:/system/{{ locum }}
    - fstype: nfs4
    - mkmnt: True
    - opts: noatime
{% endfor %}
