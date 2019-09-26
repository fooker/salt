{% import 'letsencrypt/init.sls' as letsencrypt %}
{% import 'backup/client/init.sls' as backup %}


include:
  - mail.common
  - redis
  - unbound


mail.rspamd:
  pkg.installed:
    - name: rspamd

  service.running:
    - name: rspamd
    - enable: True
    - require:
      - pkg: mail.rspamd

mail.rspamd.conf.options:
  file.managed:
    - name: /etc/rspamd/local.d/options.inc
    - source: salt://mail/rspamd/files/options.inc
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.conf.redis:
  file.managed:
    - name: /etc/rspamd/local.d/redis.conf
    - source: salt://mail/rspamd/files/redis.conf.j2
    - template: jinja
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.conf.arc:
  file.managed:
    - name: /etc/rspamd/local.d/arc.conf
    - source: salt://mail/rspamd/files/arc.conf
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.conf.classifier-bayes:
  file.managed:
    - name: /etc/rspamd/local.d/classifier-bayes.conf
    - source: salt://mail/rspamd/files/classifier-bayes.conf
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.conf.dkim_signing:
  file.managed:
    - name: /etc/rspamd/local.d/dkim_signing.conf
    - source: salt://mail/rspamd/files/dkim_signing.conf.j2
    - template: jinja
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.conf.fuzzy:
  file.managed:
    - name: /etc/rspamd/local.d/fuzzy.conf
    - source: salt://mail/rspamd/files/fuzzy.conf
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.conf.greylist:
  file.managed:
    - name: /etc/rspamd/local.d/greylist.conf
    - source: salt://mail/rspamd/files/greylist.conf
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.conf.milter_headers:
  file.managed:
    - name: /etc/rspamd/local.d/milter_headers.conf
    - source: salt://mail/rspamd/files/milter_headers.conf
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.conf.phishing:
  file.managed:
    - name: /etc/rspamd/local.d/phishing.conf
    - source: salt://mail/rspamd/files/phishing.conf
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.conf.replies:
  file.managed:
    - name: /etc/rspamd/local.d/replies.conf
    - source: salt://mail/rspamd/files/replies.conf
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.conf.worker-controller:
  file.managed:
    - name: /etc/rspamd/local.d/worker-controller.inc
    - source: salt://mail/rspamd/files/worker-controller.inc.j2
    - template: jinja
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.conf.worker-normal:
  file.managed:
    - name: /etc/rspamd/local.d/worker-normal.inc
    - source: salt://mail/rspamd/files/worker-normal.inc
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.conf.worker-proxy:
  file.managed:
    - name: /etc/rspamd/local.d/worker-proxy.inc
    - source: salt://mail/rspamd/files/worker-proxy.inc
    - makedirs: True
    - watch_in:
      - service: mail.rspamd

mail.rspamd.dkim:
  file.managed:
    - name: /var/lib/rspamd/dkim.key
    - contents_pillar: mail:dkim:privkey
    - user: rspamd
    - group: rspamd
    - mode: 440
    - watch_in:
      - service: mail.rspamd

{{ letsencrypt.certificate('spam', ['spam.open-desk.net', 'spam.' + pillar.mail.servers[grains.id] + '.open-desk.net']) }}

mail.rspamd.web:
  file.managed:
    - name: /etc/httpd/conf/vhosts/spam.conf
    - source: salt://mail/rspamd/files/httpd.conf.j2
    - makedirs: True
    - template: jinja
    - require:
      - letsencrypt.domains.spam

{{ backup.dir('rspamd', '/var/lib/rspamd/') }}
