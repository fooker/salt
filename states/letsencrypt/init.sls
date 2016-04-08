{% import 'glusterfs/init.sls' as glusterfs %}


include:
  - common.cron


letsencrypt:
  pkg.installed:
    - sources:
      - acme-tiny: salt://letsencrypt/acme-tiny-0.0.1.f61f72c-1-any.pkg.tar.xz

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

{% if grains['role'] != 'worker' %}
letsencrypt.wellknown:
  file.directory:
    - name: /run/letsencrypt
{% else %}
{{ glusterfs.volume('letsencrypt', '/run/letsencrypt', False) }}
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

letsencrypt.domains.{{ module }}.crt:
  cmd.wait:
    - name: ( acme_tiny
                  --account-key /etc/letsencrypt/account.key
                  --csr /etc/letsencrypt/domains/{{ module }}.csr
                  --acme-dir /var/run/letsencrypt
            &&
              curl https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem
                  --silent
            ) > /etc/letsencrypt/domains/{{ module }}.crt
    - watch:
      - cmd: letsencrypt.domains.{{ module }}.csr

letsencrypt.domains.{{ module }}.cron:
  cron.present:
    - name: ( acme_tiny
                  --account-key /etc/letsencrypt/account.key
                  --csr /etc/letsencrypt/domains/{{ module }}.csr
                  --acme-dir /var/run/letsencrypt
            &&
              curl https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem
                  --silent
            ) > /etc/letsencrypt/domains/{{ module }}.crt
    - minute: random
    - hour: random
    - daymonth: random
    - month: '*/2'
    - identifier: letsencrypt-{{ module }}
{% endmacro %}

