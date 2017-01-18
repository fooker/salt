{% import 'nfs/client/init.sls' as nfs %}

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

#letsencrypt.root.crt:
#  file.managed:
#    - name: /etc/letsencrypt/root.crt
#    - source: https://letsencrypt.org/certs/isrgrootx1.pem
#    - source_hash: sha512=3032f6c4a2be35fb0d1d5a75447241d8f67b8d3175fdfee25bb98f5b43910447e4a0348e03768847259b140b948108b2d60a2eef64715a9db023bdb0c012d03c

letsencrypt.root.crt:
  file.managed:
    - name: /etc/letsencrypt/root.crt
    - source: https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem
    - source_hash: sha512=0fa893f751f0880c7d89c398cae9708f5ff04d466832fb6160a824395032259ac52e02a44da531d0f8bf7e310298b0067b1e8257f816d3223034f391ecba491d

{% if grains['role'] != 'worker' %}
letsencrypt.wellknown:
  file.directory:
    - name: /run/letsencrypt
{% else %}
{{ nfs.mount('letsencrypt', 'letsencrypt', '/run/letsencrypt') }}
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
  cmd.run:
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
    - onchanges:
      - file: /etc/letsencrypt/domains/{{ module }}.cfg
      - file: /etc/letsencrypt/domains.key

letsencrypt.domains.{{ module }}.crt:
  cmd.run:
    - name: /usr/local/bin/letsencrypt-fetch {{ module }}
    - onchanges:
      - cmd: letsencrypt.domains.{{ module }}.csr
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

