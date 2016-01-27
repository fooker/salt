backup:
  retentions:
    - id: hourly
      count: 42
      interval:
        minute: 0
        hour: '*/8'
    - id: daily
      count: 28
      interval:
        minute: 0
        hour: 4
    - id: weekly
      count: 16
      interval:
        minute: 0
        hour: 5
        dayweek: 0
    - id: monthly
      count: 24
      interval:
        minute: 0
        hour: 6
        daymonth: 1

  ssh:
    key:
      public: |
        AAAAC3NzaC1lZDI1NTE5AAAAIKdlNVgr8puDdCv6XS6RZTLFw2ygKEBH0kAVXdm3Z+yw
      secret: |
        -----BEGIN PGP MESSAGE-----
        hQEMA0EEvUwCdTjhAQf/RCKxCGbtnonzodNmuAHDFZ5vUGq8StRd/nNNYZ7kGc6d
        Hvq42rYhZrh4cPdBGQ9ndpYkpOCGDNZyz2hUdKOC/oSABNSsTZ3dgHZmAUaqAxTG
        2X+cGFEsVmHV1etLBnH8LWKFxenvKpWamZoUiZhA/sF8JPUkbwXIQQ5QOaAb2Tf4
        Luf+0VviqiY0HG48KsdnQgebcSuSHRjXv5UhnCD6Hw7x65dPS0ytlCMp7IpWHB1R
        /PBHG+KcOamOPEKJsj77O1w3Gklbs2MI3pet8WBrTJmc6fmJvvD4HUa8Qkm8q7BA
        CtuRwrWKzXZ1lIbrGOrZVdtMrs2Qva7tc9CfrKRhLNLAlgE8prwzVh1XCsHQvoqo
        AnVtUNnsCDI/scCcrSqonZvRLUzD91gsZiM4Qws8WldV4CoHbn/vjoeoT8kiYXdz
        2CYr2tlbJsd3f3E3LYCu9tRzm6PlS3vomoQSlfVKydmfZR3uLXp6D9ckCTj3NRjI
        1T7zPUdcbwS+XqBj6gO43hvuc1M+iVAEcmSjl82GBqCvAPS+eFNhQm88Dc3T3VFG
        /UJ8z5OFcBk3h6/kEZ3+cKb0oHi9z0PoR5FjPkWITjTE/XBqLK7vJJNWvuooDIb3
        ebX5VOPRx0ifhR7v0Xa0tVGyyPjnmmXzGHlU3dbi456S+efdIT1V/Nl8vvUaCyy6
        j1t0nTGFoBgj3MimEEN/P4AmV4H3VZz3+Ke/JE9KQ0nzSyma/DitA7aIXpKG9hGc
        XpmarT6d+s0gf/9J/HJrgKwM5u5myy1yyyM6qokrjDqGOJpA9p8Vbw==
        =YGY1
        -----END PGP MESSAGE-----
      type: ed25519

