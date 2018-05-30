tinc:
  pkg.installed:
    - name: tinc
  file.directory:
    - name: /etc/tinc
  service.running:
    - enable: True
    - name: tinc
    - require:
      - file: tinc
      - pkg: tinc


{% for instance, config in pillar.tinc.items() if grains.id in config.hosts %}

tinc.{{ instance }}:
  service.running:
    - enable: True
    - name: 'tinc@{{ instance | replace('-', '\\\\x2d') }}'
    - require:
      - pkg: tinc
    - watch:
      - file: /etc/tinc/{{ instance }}/*

{% set bridged = ('bridged' in config.hosts[grains.id] and config.hosts[grains.id].bridged) %}


{% if bridged %}

tinc.{{ instance }}.network:
  file.managed:
    - name: /etc/systemd/network/40-{{ config.interface }}.tinc.network
    - source: salt://tinc/files/network.j2
    - template: jinja
    - context:
        instance: {{ instance }}
    - makedirs: True

{% endif %}


tinc.{{ instance }}.key:
  file.managed:
    - name: /etc/tinc/{{ instance }}/rsa_key.priv
    - contents: |
        {{ config.hosts[grains.id].private_key | indent(8) }}
    - mode: 600
    - makedirs: True


tinc.{{ instance }}.hosts:
  file.directory:
    - name: /etc/tinc/{{ instance }}/hosts/
    - makedirs: True
    - clean: True


{% for host in config.hosts %}
{% set identity = config.hosts[host].identity | default(host | replace('-', '_')) %}

tinc.{{ instance }}.hosts.{{ host }}:
  file.managed:
    - name: /etc/tinc/{{ instance }}/hosts/{{ identity }}
    - source: salt://tinc/files/host.j2
    - makedirs: True
    - template: jinja
    - context:
        instance: {{ instance }}
        host: {{ host }}
    - require_in:
      - file: tinc.{{ instance }}.hosts


{% if host != grains.id and 'port' in config.hosts[host] %}
tinc.{{ instance }}.hosts.{{ host }}.connect:
  file.accumulated:
    - name: connects
    - filename: /etc/tinc/{{ instance }}/tinc.conf
    - text: {{ identity }}
    - require_in:
      - file: tinc.{{ instance }}.conf
{% endif %}

{% endfor %}


tinc.{{ instance }}.conf:
  file.managed:
    - name: /etc/tinc/{{ instance }}/tinc.conf
    - source: salt://tinc/files/tinc.conf.j2
    - context:
        instance: {{ instance }}
        bridged: {{ bridged }}
    - template: jinja
    - makedirs: True


{% if 'port' in config.hosts[grains.id] %}

tinc.{{ instance }}.ferm:
  file.managed:
    - name: /etc/ferm.d/tinc.{{ instance }}.conf
    - source: salt://tinc/files/ferm.conf.j2
    - makedirs: True
    - template: jinja
    - context:
        instance: {{ instance }}
        port: {{ config.hosts[grains.id].port }}
    - require_in:
      - file: ferm

{% endif %}

{% endfor %}
