{% import 'letsencrypt/init.sls' as letsencrypt %}
{% import 'mariadb/init.sls' as mariadb %}


mail.user:
  group.present:
    - name: vmail
    - gid: 800
    - system: True

  user.present:
    - name: vmail
    - fullname: Virtual Mail User
    - shell: /bin/false
    - home: /srv/mail
    - uid: 800
    - gid: 800
    - groups:
      - vmail

{{ mariadb.database('mail') }}
{{ letsencrypt.certificate('mail', ['mail.open-desk.net', 'imap.open-desk.net', 'smtp.open-desk.net', 'mx.open-desk.net', 'mx1.open-desk.net', 'mx2.open-desk.net']) }}
