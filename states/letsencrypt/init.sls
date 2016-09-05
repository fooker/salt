include:
  - common.cron


letsencrypt:
  pkg.installed:
    - sources:
      - acme-tiny: salt://letsencrypt/acme-tiny-0.0.1.daba51d-2-any.pkg.tar.xz

letsencrypt.script:
  file.managed:
    - name: /usr/local/bin/letsencrypt-fetch
    - source: salt://letsencrypt/letsencrypt-fetch
    - mode: 755

letsencrypt.account.key:
  file.managed:
    - name: /etc/letsencrypt/account.key
    - contents_pillar: letsencrypt:account:key
    - makedirs: True

letsencrypt.domains.key:
  file.managed:
    - name: /etc/letsencrypt/domains.key
    - contents_pillar: letsencrypt:domains:key
    - makedirs: True

letsencrypt.root.crt:
  file.managed:
    - name: /etc/letsencrypt/root.crt
    - source: https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem
    - source_hash: sha512=a345f020969b9a1f60cede5873e282d238c2e8c5bfa0cf163518cee6d5fb78525158425ea64ca7b7fdec8db332000bb997a8b8863b0e31afab230a29da53bb76

{% if grains['role'] != 'worker' %}
letsencrypt.wellknown:
  file.directory:
    - name: /run/letsencrypt
{% else %}
letsencrypt.wellknown:
  mount.mounted:
    - name: /run/letsencrypt
    - device: /mnt/data/letsencrypt
    - fstype: none
    - mkmnt: True
    - opts: bind
    - persist: True
{% endif %}


{% macro certificate(module, domains) %}
letsencrypt.domains.{{ module }}.cfg:
  file.managed:
    - name: /etc/letsencrypt/domains/{{ module }}.cfg
    - source: salt://letsencrypt/domain.cfg.tmpl
    - makedirs: True
    - template: jinja
    - context:
        domains: [{{ domains | map('yaml_dquote') | join(',') }}]

letsencrypt.domains.{{ module }}.csr:
  cmd.wait:
    - name: |
        openssl req \
            -batch \
            -verbose \
            -new \
            -out /etc/letsencrypt/domains/{{ module }}.csr \
            -key /etc/letsencrypt/domains.key \
            -sha256 \
            -subj '/' \
            -config /etc/letsencrypt/domains/{{ module }}.cfg \
    - watch:
      - file: /etc/letsencrypt/domains/{{ module }}.cfg
      - file: /etc/letsencrypt/domains.key

letsencrypt.domains.{{ module }}.crt:
  cmd.wait:
    - creates: /etc/letsencrypt/domains/{{ module }}.crt
    - name: /usr/local/bin/letsencrypt-fetch {{ module }}
    - watch:
      - cmd: letsencrypt.domains.{{ module }}.csr
    - require:
      - file: /etc/letsencrypt/root.crt

letsencrypt.domains.{{ module }}.cron:
  cron.present:
    - name: /usr/local/bin/letsencrypt-fetch {{ module }}
    - minute: random
    - hour: random
    - daymonth: random
    - month: '*/2'
    - identifier: letsencrypt-{{ module }}
{% endmacro %}

