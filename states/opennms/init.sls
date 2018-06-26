{% import 'rsnapshot/target/init.sls' as rsnapshot %}
{% import 'nginx/init.sls' as nginx %}


include:
  - nginx


{{ nginx.vhost('opennms', 'salt://nginx/files/vhost/proxy.conf.j2', ['opennms.open-desk.net'], target='127.0.0.1:8980') }}

{{ rsnapshot.target('opennms', '/opt/opennms/etc') }}
