{% import 'nfs/client/init.sls' as nfs %}

include:
  - common.cron


letsencrypt:
  pkg.installed:
    - sources:
      - acme-tiny: salt://letsencrypt/files/acme-tiny-0.0.1.daba51d-2-any.pkg.tar.xz

letsencrypt.script:
  file.managed:
    - name: /usr/local/bin/letsencrypt-fetch
    - source: salt://letsencrypt/files/letsencrypt-fetch
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
    - source: https://letsencrypt.org/certs/letsencryptauthorityx3.pem.txt
    - source_hash: sha512=0f93f0a2149732815d6a6948d738c718c384f0bede321d1a7e92ab397aba7a5a1724b2357b2f3c4cbb46fb16d0ea67cae1e7f249b79ba4227df774f1e9de37fe

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
    - source: salt://letsencrypt/files/domain.cfg.j2
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

