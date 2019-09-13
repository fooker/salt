include:
  - mail.common


mail.postfix:
  pkg.installed:
    - name: postfix
  
  service.running:
    - name: postfix
    - enable: True
    - reuqire:
      - pkg: postfix
    - watch:
      - letsencrypt.domains.mail

mail.postifx.config.main:
  file.managed:
    - name: /etc/postfix/main.cf
    - source: salt://mail/postfix/files/main.cf.j2
    - makedirs: True
    - template: jinja
    - watch_in:
      - service: postfix

mail.postifx.config.master:
  file.managed:
    - name: /etc/postfix/master.cf
    - source: salt://mail/postfix/files/master.cf.j2
    - makedirs: True
    - template: jinja
    - watch_in:
      - service: postfix

mail.postifx.config.mailbox_maps:
  file.managed:
    - name: /etc/postfix/mailbox_maps.cf
    - source: salt://mail/postfix/files/mailbox_maps.cf.j2
    - makedirs: True
    - template: jinja
    - watch_in:
      - service: postfix

mail.postifx.config.alias_maps:
  file.managed:
    - name: /etc/postfix/alias_maps.cf
    - source: salt://mail/postfix/files/alias_maps.cf.j2
    - makedirs: True
    - template: jinja
    - watch_in:
      - service: postfix

mail.postifx.config.aliases:
  file.managed:
    - name: /etc/postfix/aliases
    - source: salt://mail/postfix/files/aliases.j2
    - makedirs: True
    - template: jinja
  cmd.run:
    - name: postmap hash:/etc/postfix/aliases
    - onchanges:
      - file: mail.postifx.config.aliases
    - watch_in:
      - service: postfix

mail.postfix.ferm:
  file.managed:
    - name: /etc/ferm.d/mail-postfix.conf
    - source: salt://mail/postfix/files/ferm.conf
    - makedirs: True
    - require_in:
      - file: ferm
