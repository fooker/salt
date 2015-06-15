base:
  '*':
    - network
    - ssh
    - sysctl
    - tinc
    - private.tinc
    - opennms
    - private.opennms
    - backup
    - ddclient
    - private.ddclient
    - private.dsl

  '{{ grains.id }}':
    - host.{{ grains.id }}
