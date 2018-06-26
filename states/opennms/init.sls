{% import 'rsnapshot/target/init.sls' as rsnapshot %}
{% import 'nginx/init.sls' as nginx %}


include:
  - nginx


{{ nginx.vhost('opennms', source='salt://nginx/files/vhost/proxy.conf.j2', domains=['opennms.open-desk.net'], target='127.0.0.1:8980') }}
{{ nginx.vhost('opennms.to_ssl', source='salt://nginx/files/vhost/redirect-ssl.conf.j2', ssl=False, domains=['opennms.open-desk.net']) }}

{{ rsnapshot.target('opennms', '/opt/opennms/etc') }}
