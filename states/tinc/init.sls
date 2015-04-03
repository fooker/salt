tinc:
  pkg:
    - installed
    - name: tinc
  service:
    - running
    - enable: True
    - name: tincd@mngt
    - require:
      - pkg: tinc
    - watch:
      - file: /etc/tinc/mngt/*


tinc.conf:
  file:
    - managed
    - name: /etc/tinc/mngt/tinc.conf
    - source: salt://tinc/conf.tmpl
    - makedirs: True
    - template: jinja


tinc.key:
  file:
    - managed
    - name: /etc/tinc/mngt/rsa_key.priv
    - contents: |
        {{ pillar['tinc']['keys']['private'] | indent(8) }}


{#
tinc.host:
  file:
    - managed
    - name: 
  

tinc.host.{{ grains['id'] | replace('.', '_') | replace('-', '_') }}:
  file:
    - managed
    - name: /etc/tinc/mngt/hosts/{{ grains['id'] | replace('.', '_') | replace('-', '_') }}
    - source: salt://tinc/host.tmpl
    - makedirs: True
    - template: jinja


{% for peer, contents in salt['mine.get']('*', 'cmd.run').items() if peer != grains['id'] %}
tinc.host.{{ peer | replace('.', '_') | replace('-', '_') }}:
  file:
    - managed
    - name: /etc/tinc/mngt/hosts/{{ peer | replace('.', '_') | replace('-', '_') }}
    - contents: |
        {{ contents | indent(8) }}
    - makedirs: True
{% endfor %}
#}

