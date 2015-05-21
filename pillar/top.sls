base:
  '*':
    - network
    - ssh
    - sysctl
    - tinc
    - backup

  '{{ grains.id }}':
    - host.{{ grains.id }}
