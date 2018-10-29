pacman.hooks.conf:
  file.uncomment:
    - name: /etc/pacman.conf
    - regex: 'HookDir *= /etc/pacman.d/hooks/'

pacman.hooks.dir:
  file.directory:
    - name: '/etc/pacman.d/hooks'

pacman.stuff:
  file.append:
    - name: '/etc/pacman.conf'
    - text: |
        [stuff]
        Server = https://aurblobs.open-desk.net/stuff

pacman.stuff.key:
  file.managed:
    - name: '/etc/pacman.d/stuff.gpg'
    - source: 'https://aurblobs.open-desk.net/stuff/stuff.gpg'
    - source_hash: b5e69a432c48f046260141965b06bf40ed412e6410929b8c9e9721de4396e0f4320da6ae077bfa5bfa5cdb9ad2b0de2112908fb4c747fcfb47e422ad257eb842

  cmd.run:
    - name: 'pacman-key --add /etc/pacman.d/stuff.gpg && pacman-key --lsign-key 9092C185099C935B2EDBAE7689EF0F826E3E6A09'
    - onchanges:
      - file: pacman.stuff.key

