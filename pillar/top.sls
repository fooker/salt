base:
  '*':
    - common

  '{{ grains.id }}':
    - {{ grains.id }}
