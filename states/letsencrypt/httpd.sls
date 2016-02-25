include:
  - letsencrypt


letsencrypt.httpd.conf:
  file.managed:
    - name: /etc/httpd/conf/httpd.letsencrypt.conf
    - source: salt://letsencrypt/httpd.conf

