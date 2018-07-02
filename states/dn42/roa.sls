include:
  - pullomatic


dn42.roa.mkroa:
  file.managed:
    - name: /usr/local/lib/dn42/mkroa-bird2
    - source: salt://dn42/files/mkroa-bird2
    - makedirs: True
    - mode: 755

dn42.roa.pullomatic:
  file.managed:
    - name: /etc/pullomatic/dn42-roa
    - source: salt://dn42/files/roa.pullomatic
    - makedirs: True
    - require:
      - file: dn42.roa.mkroa
    - require_in:
      - file: pullomatic
