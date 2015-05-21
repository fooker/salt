base:
  '*':
    - network
    - ssh
    - sysctl
    - tinc
    - private.tinc
    - backup

  '{{ grains.id }}':
    - host.{{ grains.id }}
