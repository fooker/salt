tinc:
  pkg.installed:
    - name: tinc
  service.running:
    - enable: True
    - name: tinc
    - require:
      - pkg: tinc


{% for instance, config in pillar['tinc'].items() if grains.id in config.hosts %}

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

tinc.{{ instance }}.netdev:
  file.managed:
    - name: /etc/systemd/network/40-{{ config.interface }}.tinc.netdev
    - source: salt://tinc/netdev.tmpl
    - context:
        instance: {{ instance }}
        bridged: True
    - template: jinja
    - makedirs: True


tinc.{{ instance }}.network:
  file.managed:
    - name: /etc/systemd/network/40-{{ config.interface }}.tinc.network
    - source: salt://tinc/network.tmpl
    - template: jinja
    - context:
        instance: {{ instance }}
    - makedirs: True

{% else %}

tinc.{{ instance }}.netdev:
  file.managed:
    - name: /etc/systemd/network/70-{{ config.interface }}.netdev
    - source: salt://tinc/netdev.tmpl
    - context:
        instance: {{ instance }}
        bridged: False
    - template: jinja
    - makedirs: True

{% endif %}


tinc.{{ instance }}.key:
  file.managed:
    - name: /etc/tinc/{{ instance }}/rsa_key.priv
    - contents: |
        {{ config.hosts[grains.id].private_key | indent(8) }}
    - mode: 600


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
    - source: salt://tinc/host.tmpl
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
    - source: salt://tinc/tinc.conf.tmpl
    - context:
        instance: {{ instance }}
        bridged: {{ bridged }}
    - template: jinja
    - makedirs: True


{% if 'port' in config.hosts[grains.id] %}

tinc.{{ instance }}.ferm:
  file.managed:
    - name: /etc/ferm.d/tinc.{{ instance }}.conf
    - source: salt://tinc/ferm.conf.tmpl
    - template: jinja
    - context:
        instance: {{ instance }}
        port: {{ config.hosts[grains.id].port }}
    - require_in:
      - file: ferm

{% endif %}

{% endfor %}
