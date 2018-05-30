ssmtp:
  pkg.installed:
    - name: ssmtp
  file.managed:
    - name: /etc/ssmtp/ssmtp.conf
    - source: salt://common/files/ssmtp.conf.j2
    - makedirs: True
    - template: jinja
