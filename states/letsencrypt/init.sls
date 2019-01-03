letsencrypt.dehydrated:
  pkg.installed:
    - name: dehydrated
  service.running:
    - name: dehydrated.timer
    - enable: True
    - watch:
      - pkg: letsencrypt.dehydrated

letsencrypt.dehydrated.config:
  file.managed:
    - name: /etc/dehydrated/config
    - source: salt://letsencrypt/files/config.j2
    - makedirs: True
    - template: jinja

letsencrypt.dehydrated.register:
  cmd.run:
    - name: '/usr/bin/dehydrated --register --accept-terms'
    - unless: /usr/bin/dehydrated --register
    - require:
      - file: letsencrypt.dehydrated.config

letsencrypt.dehydrated.domains:
  file.managed:
    - name: /etc/dehydrated/domains.txt
    - source: salt://letsencrypt/files/domains.txt.j2
    - makedirs: True
    - template: jinja

letsencrypt.dehydrated.renew:
  cmd.run:
    - name: '/usr/bin/dehydrated --cron'
    - onchanges:
      - file: letsencrypt.dehydrated.domains
    - require:
      - cmd: letsencrypt.dehydrated.register

{% macro certificate(module, domains) %}
letsencrypt.domains.{{ module }}:
  file.accumulated:
    - name: domains
    - filename: /etc/dehydrated/domains.txt
    - text: '{{ domains|join(' ') }} > {{ module }}'
    - watch_in:
      - file: letsencrypt.dehydrated.domains
{% endmacro %}
