rsnapshot:
  pkg:
    - installed
    - name: rsnapshot

rsnapshot.conf:
  file:
    - managed
    - name: /etc/rsnapshot.conf
    - source: salt://rsnapshot/rsnapshot.conf.tmpl
    - makedirs: True
    - template: jinja

{# for host, contents in salt['publish.publish']('*', 'template.render', 'salt://rsnapshot/target/rsnapshot.conf.tmpl').items() %}
rsnapshot.conf.{{ host }}:
  file:
    - managed
    - name: /etc/rsnapshot.d/{{ host }}
    - contents: |
        {{ contents|indent(8) }}
    - makedirs: True
{% endfor #}
