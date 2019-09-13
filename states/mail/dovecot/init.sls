{% import 'rsnapshot/target/init.sls' as rsnapshot %}


include:
  - mail.common


mail.dovecot:
  pkg.installed:
    - pkgs:
      - dovecot
      - clucene
      - pigeonhole
  
  service.running:
    - name: dovecot
    - enable: True
    - reuqire:
      - pkg: dovecot
    - watch:
      - letsencrypt.domains.mail

mail.dovecot.config:
  file.directory:
    - name: /etc/dovecot/conf.d
    - makedirs: True
    - clean: True
    - require:
      - pkg: mail.dovecot
    - watch_in:
      - service: mail.dovecot

mail.dovecot.config.main:
  file.managed:
    - name: /etc/dovecot/dovecot.conf
    - source: salt://mail/dovecot/files/dovecot.conf.j2
    - makedirs: True
    - template: jinja
    - require_in:
      - file: mail.dovecot.config
    - watch_in:
      - service: mail.dovecot

mail.dovecot.config.mysql:
  file.managed:
    - name: /etc/dovecot/mysql.conf.ext
    - source: salt://mail/dovecot/files/mysql.conf.ext.j2
    - makedirs: True
    - template: jinja
    - require_in:
      - file: mail.dovecot.config
    - watch_in:
      - service: mail.dovecot

mail.dovecot.dh:
  cmd.run:
    - name: openssl dhparam -out /etc/dovecot/dh.pem 2048
    - creates: /etc/dovecot/dh.pem
    - require_in:
      - file: mail.dovecot.config
    - watch_in:
      - service: mail.dovecot

{% for config in [
  '10-master',
  '20-auth',
  '20-mail',
  '20-replication',
  '20-ssl',
  '25-mailboxes',
  '30-imap',
  '30-lmtp',
  '30-sieve',
  '60-stats',
] %}
mail.dovecot.config.{{ config }}:
  file.managed:
    - name: /etc/dovecot/conf.d/{{ config }}.conf
    - source: salt://mail/dovecot/files/conf.d/{{ config }}.conf.j2
    - makedirs: True
    - template: jinja
    - require_in:
      - file: mail.dovecot.config
    - watch_in:
      - service: mail.dovecot
{% endfor %}

mail.dovecot.sieve:
  file.directory:
    - name: /etc/dovecot/sieve
    - makedirs: True
    - clean: True
    - exclude_pat: '*.svbin'
    - require:
      - pkg: mail.dovecot
    - watch_in:
      - service: mail.dovecot
    - onchanges_in:
      - file: mail.dovecot.sieve.compile

mail.dovecot.sieve.compile:
  cmd.run:
    - name: '/usr/bin/sievec /etc/dovecot/sieve'
    - require:
      - pkg: mail.dovecot

{% for sieve in [
  'report-ham',
  'report-spam',
] %}
mail.dovecot.sieve.{{ sieve }}:
  file.managed:
    - name: /etc/dovecot/sieve/{{ sieve }}.sieve
    - source: salt://mail/dovecot/files/sieve/{{ sieve }}.sieve
    - makedirs: True
    - require_in:
      - file: mail.dovecot.sieve
    - onchanges_in:
      - cmd: mail.dovecot.sieve.compile
{% endfor %}

mail.dovecot.sieve.pipes:
  file.recurse:
    - name: /usr/lib/dovecot/sieve/pipes
    - source: salt://mail/dovecot/files/sieve/pipes
    - file_mode: keep
    - clean: True

mail.dovecot.ferm:
  file.managed:
    - name: /etc/ferm.d/mail-dovecot.conf
    - source: salt://mail/dovecot/files/ferm.conf.j2
    - makedirs: True
    - template: jinja
    - require_in:
      - file: ferm

{{ rsnapshot.target('mail', '/srv/mail/') }}
