{% set instance = 'mngt' %}

tinc:
  pkg.installed:
    - name: tinc
  service.running:
    - enable: True
    - name: tinc
    - require:
      - pkg: tinc

tinc.{{ instance }}:
  service.running:
    - enable: True
    - name: 'tinc@{{ instance | replace('-', '\\\\x2d') }}'
    - require:
      - pkg: tinc
    - watch:
      - file: /etc/tinc/{{ instance }}/*


tinc.{{ instance }}.conf:
  file.managed:
    - name: /etc/tinc/{{ instance }}/tinc.conf
    - source: salt://tinc/tinc.conf.tmpl
    - context:
        bridged: {{ 'bridged' in pillar['tinc']['hosts'][grains['id']] and pillar['tinc']['hosts'][grains['id']]['bridged'] }}
    - template: jinja
    - makedirs: True


{% if 'bridged' in pillar['tinc']['hosts'][grains['id']] and pillar['tinc']['hosts'][grains['id']]['bridged'] -%}

tinc.{{ instance }}.netdev:
  file.managed:
    - name: /etc/systemd/network/40-int.mngt.tinc.netdev
    - source: salt://tinc/netdev.tmpl
    - context:
        bridged: True
    - template: jinja
    - makedirs: True


tinc.{{ instance }}.network:
  file.managed:
    - name: /etc/systemd/network/40-int.mngt.tinc.network
    - source: salt://tinc/network.tmpl
    - template: jinja
    - makedirs: True

{%- else -%}

tinc.{{ instance }}.netdev:
  file.managed:
    - name: /etc/systemd/network/70-int.mngt.netdev
    - source: salt://tinc/netdev.tmpl
    - context:
        bridged: False
    - template: jinja
    - makedirs: True

{%- endif %}


tinc.{{ instance }}.key:
  file.managed:
    - name: /etc/tinc/{{ instance }}/rsa_key.priv
    - contents: |
        {{ pillar['tinc']['hosts'][grains['id']]['priv'] | indent(8) }}
    - mode: 600


{%- for name, host in pillar['tinc']['hosts'].items() %}

tinc.{{ instance }}.host.{{ name }}:
  file.managed:
    - name: /etc/tinc/{{ instance }}/hosts/{{ name | replace('-', '_') }}
    - source: salt://tinc/host.tmpl
    - context:
        host: {{ name }}
    - template: jinja
    - makedirs: True

{% endfor -%}


{%- if 'ext' in pillar['addresses'][grains['id']] and 'hostname' in pillar['addresses'][grains['id']]['ext'] %}

tinc.{{ instance }}.ferm:
  file.managed:
    - name: /etc/ferm.d/tinc.{{ instance }}.conf
    - source: salt://tinc/ferm.conf.tmpl
    - template: jinja
    - makedirs: True

{% endif -%}
