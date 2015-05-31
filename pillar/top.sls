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

  '{{ grains.id }}':
    - host.{{ grains.id }}
