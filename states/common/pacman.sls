pacman.hooks.conf:
  file.uncomment:
    - name: /etc/pacman.conf
    - regex: 'HookDir *= /etc/pacman.d/hooks/'

pacman.hooks.dir:
  file.directory:
    - name: '/etc/pacman.d/hooks'

