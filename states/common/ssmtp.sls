ssmtp:
  pkg.installed:
    - name: ssmtp
  file.managed:
    - name: /etc/ssmtp/ssmtp.conf
    - source: salt://common/ssmtp.conf.tmpl
    - makedirs: True
    - template: jinja
