## Generate IPSec key-pair with the following commands:
##  ipsec pki --gen --type rsa --outform pem --size 4096 > /etc/ipsec.d/private/self.pem
##  ipsec pki --pub --in /etc/ipsec.d/private/self.pem --outform pem > /etc/ipsec.d/certs/self.pem
##

peering:
  domains:
    hive:
      ospf:
        instance_id: 23
        preference: 1000
      exports:
        ip4:
          - 192.168.33.0/24
        ip6:
          - fd4c:8f0:aff2::/64
      filters:
        ip4:
          - 192.168.33.1/32
          - 192.168.33.2/32
          - 192.168.33.3/32
        ip6:
          - fd4c:8f0:aff2::1/128
          - fd4c:8f0:aff2::2/128
          - fd4c:8f0:aff2::3/128
    dn42:
      bgp:
        as: 4242421271
        preference: 200
      babel:
      exports:
        ip4:
          - 172.23.200.0/24
        ip6:
          - fd79:300d:6056::/48
      filters:
        ip4:
          - 172.20.0.0/14{21,29} # dn42
          #          - 172.20.0.0/24{28,32} # ..
          #          - 172.21.0.0/24{28,32} # ..
          #          - 172.22.0.0/24{28,32} # ..
          #          - 172.23.0.0/24{28,32} # ..
          - 172.31.0.0/16+       # ChaosVPN
          - 10.0.0.0/8+          # Freifunk
        ip6:
          - fc00::/7{44,64}      # ULAs

  interfaces:
    north-zitadelle:
      hive:
        ip4:
          address: 192.168.33.1
          network: 192.168.33.1
          netmask: 32
        ip6:
          address: fd4c:8f0:aff2::1
          network: fd4c:8f0:aff2::1
          netmask: 128
      dn42:
        ip4:
          address: 172.23.200.1
          network: 172.23.200.1
          netmask: 32
        ip6:
          address: fd79:300d:6056::1
          network: fd79:300d:6056::1
          netmask: 128
    south-zitadelle:
      hive:
        ip4:
          address: 192.168.33.2
          network: 192.168.33.2
          netmask: 32
        ip6:
          address: fd4c:8f0:aff2::2
          network: fd4c:8f0:aff2::2
          netmask: 128
      dn42:
        ip4:
          address: 172.23.200.2
          network: 172.23.200.2
          netmask: 32
        ip6:
          address: fd79:300d:6056::2
          network: fd79:300d:6056::2
          netmask: 128
    bunker:
      hive:
        ip4:
          address: 192.168.33.3
          network: 192.168.33.3
          netmask: 32
        ip6:
          address: fd4c:8f0:aff2::3
          network: fd4c:8f0:aff2::3
          netmask: 128
    router:
      dn42:
        ip4:
          address: 172.23.200.129
          network: 172.23.200.128
          netmask: 25
        ip6:
          address: fd79:300d:6056:1::0
          network: fd79:300d:6056:1::0
          netmask: 64

  peers:
    major:
      protos:
        - bgp
      as: 4242422600
      domains:
        - dn42
      netdev: major
      remote: '2a02:c205:3000:5324::42'
      ipsec:
        pubkey: |
          -----BEGIN PUBLIC KEY-----
          MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAyNsW6I5uAzxjt8E10x1c
          b59AtEeU4SC+FZyu1CKoRyVVsQkdLL42JZlpoSF99B740Z2KWWxaMY0cg9oSy1d1
          T6XQ92Exm01aEqrxys0mF7i+rkmjFGuXdoOANb3bAlJy1N84aD8z+crxzH0nwHCi
          rcKHCAOUSv40dmRZW6FJlh/+R1xBVSp7CPUfSeferTyeZ+JswawTT7r2ZTNnMka+
          8IjBRiEFRVq7D0kF7prBuaWXWl1iSB1UiUdh/SVtX8MC/BASkgcFT+g+Z5yn8LkO
          yOZ1CVIF6+AoW94E+65SK7WSJShIlzWsc1Uh5nw0F9a1Mo29ToeV2GRfT6q/pDT/
          oqpXB8NhrIMlNLIK6rDEmBW/VCUij/vaGWsEe/f1uFX5h9SvFCYPRdWw0JntqgwR
          eagKwIX+4lEXHChb3FkEfPNIAiRr2rRxDxBGyM8kxPBNfIVdAkTqqNEPPacdI27I
          oC6klzpOsNojD5oThYfagAp2dAZc2K8cZ2fB1UFDGrcVi6krP3MTwVbVOt62a0n0
          kAQJhJWPsxBvhSbCehkiWLdLRUIWdUCZfOFeADA5+QNIvmf2vpWiiiXD9Xdd+4bu
          cPjFuUwmI2Wo2D1VYUXkoYOkeOlPfv2YiPzBPoBw2vGUXRlNI4/z0HgJnAj1/ULz
          lXi8ZcGYXA1j9+zgkwVT7F8CAwEAAQ==
          -----END PUBLIC KEY-----
        ike: aes128-sha256-modp2048!
        esp: aes128-sha1-modp2048!

    cccda:
      protos:
        - bgp
      as: 4242420101
      domains:
        - dn42
      netdev: cccda
      remote: 'core1.darmstadt.ccc.de'
      wireguard:
        privkey: |
          -----BEGIN PGP MESSAGE-----
          hQEMA0EEvUwCdTjhAQf/bzOSoNdj5u3Am3cnBlnUIkFmHF5T1emWviIy8Auf1K2F
          4sy/0/+eqzPZefHjzTZdfvF04kjRnSlsmx8Fmq1E5/VlWVWH1wubkA2ml8Akp8K5
          i/Em3NYSe87WrF0J8Ku6B+JVUk182edwjli5kpcCcITK4pgtVt4L3c7dYLb+/UZ1
          taIq3VzSn/ClwlZqdQh1C2w9qWwvwVQqT1GreXL8ElMhk9tdQeADeBfGinqmZR7H
          CTS16sHdqvi0aNq0l2RnckLGXGRMgxGHM2Vbf+mUL6UrOHdIwHDBkgEdaq8u8d8K
          blhY+kFz4PEqdmfUg6UOPR0TDKdpZri7+CeOjJa5NdJnAVVa8MsuHajxZjY7sgKa
          AYSkbyWNdK38bKAjDmdlZStc3AZdcz4i9RJKtcksgkJxygr0vbMfwMrBrziuXDef
          qVKYQzgqnJAtmgm/3PjKVEd9Elo9SgV4TgHxhB++fDq+F8hik8hDwg==
          =oMa1
          -----END PGP MESSAGE-----
        pubkey: B9v1EHhXAoCNbF8WZQe3Tdrm2GhvHZi6b59a/xlpESA=

    jojo:
      protos:
        - bgp
      as: 4242423942
      domains:
        - dn42
      netdev: jojo
      remote: '2a03:4000:f:8::1'
      ipsec:
        pubkey: |
          -----BEGIN PUBLIC KEY-----
          MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAuVGnuqKpJjJTfBlUpmET
          X4behRlb5xLQbF0/5wNPMQtDztgepPyQXXUfPW2nj/WvpD07zQelQJuJyVQxAwD9
          kWbILPC5NApECw7LKqrcEfGoCxVeTdNKx5VORhKhn5+QDf5gSkZisHzTyYX/briI
          GLwSF/IMKMrd4NTK11aeDVKORa5mbNh3XoOJC1wpzRvxIahk9CgtI7Sgu2mBSHOX
          D1KgJAzwc57VfWI9GxaMh9E/9Yx2hpkz/r7EOg9lQXOEV9yd/KTrErjiBVELeBdm
          /D2AD79EAyIYR9QUIfPO8G+kHky0rUeUmdJ15i3OjlPGjxDuS1uN6DC57HHSuc2E
          ZRvIO20xv+6UZc1esjK6T0P0IN+/M4BvL7GQTwKEUDOWpNCH7LIhH7S0RH/8dcgF
          TWeBRTlLFkPRGti0Fl9O3uZ21XoL0VrybW1v4Maui+jHdOaFEucE/taCVJnwMOy5
          YFvFearXjHZK8Y0iXut8HWFAaUZSUdNM1AIw5W/yccaz/cJK8x89YtlL/1J9LPHa
          IJlc/e5D1Id/i2Y4hecuHIdzI/ijE71VRRvUXYW61/KRauG46M/mTq/tn41FtZFF
          upZ9UJqZwSIzsl/sV1YKYowJ1TVemE5GgzVBiYF06kLi7BgmQxLfU19F+PxlNFeJ
          8hTuXGN/PTVGNRrBCiQTS4cCAwEAAQ==
          -----END PUBLIC KEY-----
        ike: aes256-sha512-curve25519!
        esp: aes256-sha512-curve25519!

    maglab:
      protos:
        - bgp
      as: 4242422800
      domains:
        - dn42
      netdev: maglab
      remote: 'marvin.maglab.space'
      wireguard:
        privkey: |
          -----BEGIN PGP MESSAGE-----
          hQEMA0EEvUwCdTjhAQgAseaowIrCzWf77oYJoNWqkTVfM2t4eHHWXC4aIG0YTOtB
          XUIdB5eyOt+Kgm2TrBZBf7HP+bXTuh8ZZUCGReMF7lOOPu54OQqPGUXQK4f1SCOJ
          D/lXw2Ek4SEVuva5Qj/j97nlYblfjF4s7Dzs06HuEED+Yk9Ny0l06RlUGJSXsH4z
          W1vT20ORMSS9VitT0FojaVZ0ghXNOnU7NS5tCszky5vlyxg81ZWN8UsOKfyDH48S
          8qhJjJv6nQWjGai7qFmL2fadjPDpo7kzBYnCQxmZpbSImshY+JzEpi3bqbMl+Z8c
          nMeDEf12FPzlkUYqBGC7WZh/JYpOfzXRojrIIW9oKtJnAcrB++i2DqI6eGxQuZ31
          tmEDdJghuhV/M0nXtiP/5R08ECb3xQCfZ3olYtVi3nx4l9LL3mKx+ZytyGZ1L6j5
          757RBv/GuJwv5YaVinqUck+8sYalFx84ZJW3XfJsDenjZKIbSbYgVg==
          =bFiR
          -----END PGP MESSAGE-----
        pubkey: 1Dv0Nkr51AQu+InNvVbbpUgJtyQMsIbWilAlz3JHPTc=

    north-zitadelle:
      router_id: 0x8133feaa
      protos:
        - ibgp
        - ospf
        - babel
      domains:
        - hive
        - dn42
      netdev: x.znorth
      remote: '37.120.172.185'
      ipsec:
        pubkey: |
          -----BEGIN PUBLIC KEY-----
          MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAx4en2WDLO+F/L9NzwFFy
          5sCQCK9dQ/9+rFmTUPgnIet6oeDqvhAvXfnf/fN35a7rGfoduM5r9542Z1/JDKgU
          pTgyfx3MLNGbKu8UCLVobG1JOgUNsOFnlHmNMx+QxUTEZ+BgueSk9oRNMmyQHitm
          VLu7vSV5+dYIPi8Muh6wlAyYLavIZ0aH1mdURyV6YkHw4FwwC/ZwIRSFz2KLm1de
          P6TMhmIOYmJhlVTkczB54i0O6qud39ohuf3FkRd44rcFkTf26FMZuWg6OBLWBfw+
          plI7uMXG4JtMMJ73xqbADRS17Pzk6Hfz1LBuf77PaE4tmmM1W2L9KOO5wSTttU0q
          ijm/NNoasCi5cv5RX/SOAWYzV+yfv9OGowrZL4wfVvBH9ewDCVTZAcIABV9PfOcw
          B8zviCljQuMym4ttsZKcOpdltHAJE/A8G2eyQ9S7mDwC7J2EwzDqCZuRjSXex9Xz
          JxvDEXJJJmLQXicZRcCYJ2iUnzNg7YvtSVX2SCfpw7NCAsP8OPjZjrAIbSnbX4WT
          WoeAsKgibAOSWtzrdt8c1oXzX1lCa0LQNpqRF94ol9qV0junYBxuTQf898ng8CZ4
          +680sv2rtGxQK6fNLTZPjjQHvVvfZJ27R2T9J+8nqXJqD/KTfCVkNz8exHU8d5Or
          EH3jrhl4TejAb1oOPZa2zMECAwEAAQ==
          -----END PUBLIC KEY-----
        ike: aes256-sha512-curve25519!
        esp: aes256-sha512-curve25519!
      wireguard:
        privkey: |
          -----BEGIN PGP MESSAGE-----
          hQEMA0EEvUwCdTjhAQgAhFBmoT8DLWcZMCmSrGY31Qak2WyKzZYKY7Slsb0MdoV8
          5WCkzB4/nPFKzin73X4WT/aOPYmBcZxqYfFicxtGGAlh3pMhfnp1D49WnCRFwfUX
          T+19J4MDfS9/VqIVafMG3eHSewmvZkwH1qCiyp+FFia1Tz0d6rF8qa6cwHi7tsv9
          2hSCbiEwcAjWD6N2hmpJ86n3JHFQ0K65Xa+N2UQJmJ2gBwpd5j8X8WTdKp39Uho6
          jLRo9hsdF4xF543A8itX7PS7CK+2SnVOfamxp143KZNgK+FwOG4EI+k3uLTgoNfl
          DEuoSFkDPGClbKOtC+QzGy+eN0mG55Ol7xtMQ/4bfdJnAS4MZBV/KZwq07zjtSTp
          b0o4lVx6I1wKwApteHVgOB03xR59i5fG/jFeA5KieuqkS3zVU9wd/k+49/A1fhVJ
          +hWqPAzni5OI8jr0zB8ctRPNAGkVmdeApFyMOcjFdPW6ygb0uJfnDg==
          =Kyqn
          -----END PGP MESSAGE-----
        pubkey: WF0uVUhK4FDw8+PkdQMoi9V+UdnZcgE6Ejcpuh042Vk=

    south-zitadelle:
      router_id: 0x99bf501b
      protos:
        - ibgp
        - ospf
        - babel
      domains:
        - hive
        - dn42
      netdev: x.zsouth
      remote: '37.120.172.177'
      ipsec:
        pubkey: |
          -----BEGIN PUBLIC KEY-----
          MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEArbH1ALjvuPLCtnh7eWGg
          32xzudZJMIOr//8ctMs4xK6402u3ygyTEanvuZDPd3H2TQvKGu2lxjIZmUSD1Hyn
          SlKnLHY9jKLJT12GwgfZXKBIRVDpp/ekBLFVItA2zdPXdYCUrlBK+rmw2/rUAfuu
          z/xgAksYpyl5pwzJ6kgKU4baxR9aHUwtjDA9AeTLxzIL2oKdz3lUiJVUsEQCj2Vg
          Crbnr0YyF7KNgxiIMnVeF9Nm60VGZjJySvSiPtBoof+ISRSw1x3ktZPTSDdsli5h
          luz7nWiWLDy9DrF/gvK87y/S1TsSG7NHnsuCj/2HnwsIhAwAxq3qOxlXJTfHNpkj
          N1ynu/ydCTpAJmSAdGjAckcNCQXTQNBjVVRwXF7uYr+mz9F+HA0e5BO50TulJPfX
          +2RtqVa+b8tFau3m82VCgjYzszt6sxT6GaBxA4V+pbZlui7Qss1bv2RZATn5xk1n
          BSmJzmcuGZ4eihS219GSP3EsSl2Hg1S10+THPmkFX6HgT0lGBEj/lpvlaxhdnR0z
          Ub4tTlnZtINg18BGTqjLr7v9EFv69B2CjSzQGPDz9oXv2CXuJCKD55VfCFUXMisc
          7F+OehKtHOhdHJd3rJmjaDKKQXSc4ywwOCYcf0fKYvFUTN3Lo0eiUnfr4Gbo4i+H
          +p4kiM8V0NHFkTwuyXQNNJ0CAwEAAQ==
          -----END PUBLIC KEY-----
        ike: aes256-sha512-curve25519!
        esp: aes256-sha512-curve25519!
      wireguard:
        privkey: |
          -----BEGIN PGP MESSAGE-----
          hQEMA0EEvUwCdTjhAQf+Ps2YZbkPBBib0kdOzaOvt+9f5+y8OIXvIKyWhpm25qaa
          KioWQEnQkMtNmHbZihAD3PROMc+jtgwO34rlEo8hboaPJadSZqOjWe/yhwqFzDqo
          F+VhCWIRynP4431vrlexxGBkOAju9NGLl8dL7caxekUp/0myF/1CJN/GjgErr3nF
          MaTbxKh5gj/zS0t5BGd++OXcn72Eu42LrxCDDX6uoPkO9WrcY7Ra6KineYUkXSFd
          RxHwIyiJo8wZEcFrezRHDFBYGGa7sg8R6y5x1wm5dnJVh0LK6JS4N/5c5YlmztNq
          gY1NYcTvdfFXonOyn3W1dAol9M7LGVVOiiuYj18yFtJnAW+9qPHhT6DTD5obVWAs
          maolm0xoM6ztZKlEGPc8s8PliIJLV+gSi6Zz9IVvVNpQslvqmFA7w6dc/j5TWPkl
          j/Ey/iQvn8ZAF809UhNJ5T4t0G5w3K0/cJSSr9PxCSnd6IlJQeOixg==
          =hm7P
          -----END PGP MESSAGE-----
        pubkey: iRKAhmid+N4FQjhUAhDxTiXdo7x3p71ymQBWa1JDAn0=

    bunker:
      router_id: 0x3d44ba3c
      protos:
        - ospf
      domains:
        - hive
      netdev: x.bunker
      remote: '37.120.161.15'
      wireguard:
        privkey: |
          -----BEGIN PGP MESSAGE-----
          hQEMA0EEvUwCdTjhAQf+LSfeE9/PZYGAdZ9+NA5LFrtyk9hgm3MSfSppegsvEXtP
          N420xal0CZ3VYQsdP7oUch/hdOrNfVNlDvrLyCIRUn2wIdLv1CR8TdSaEoyvV2X6
          yUBnYiAyCFV4HuZHOdU8Pp4d6PBHbQL/5MoQgMwQbbSl3zzXPUFwuhm8xIsFqUjN
          t+k09Jkj0Ug43xQfH76HWOjal8PvD92kcB7JiQdlM6XRjOsaUqMiVD3Mclvb73u6
          nUl728i+hmlkpzRC5i+yO5/zZ1EuryJpx1tXJQroaWiT7W8bLCtCwmPP/0VnHVxn
          tRIo+/PuyYMTu86js3KFIEpkO1jmegF3jIoBV2cm/tJnATIXvKzcbfgO2WDMtBtO
          OdCgsjgh+v6NDf4hdwqhRsWo80mhIrJJIcV3Gp4YFGu0Nd8iOQkDnvDpSxiiVhDm
          9jvovRmZ3pAwIiIHSxQDeyngxixvHKW4G8tiAvPqgkEvM7feK029iw==
          =O2+W
          -----END PGP MESSAGE-----
        pubkey: Nx1+nNpAExDXuRBabZpPsDOErSyTB1Nd2UUkvI98Gy0=

    router:
      router_id: 0x4364370d
      protos:
        - babel
      domains:
        - dn42
      netdev: x.router
      wireguard:
        privkey: |
          -----BEGIN PGP MESSAGE-----
          hQEMA0EEvUwCdTjhAQf+MjBissQvBqcihqqT57lXxw6txI6r8rdA9bh+urY4aPZM
          jTkEQYzOiv/20OKM1BF9jE14xrXTLIc+880WTBvu1YP15DYogTVtxfHyjaX1mdAK
          metPJBoyVS9Tqsu4XDd+Zz9m5vIX+X73dsoaPN4gx67I3nUj3soaEsEfmlNKyYzN
          Zxdhq5Y22NS2b6c4WrMhDhC7hqf08thERAWC+dOgrwnv4DzcKIo0aWP5mEf5YtBe
          QgWZ/IQQrnmrFx3bnSH+pEHRw66URN2TsEc5Lb9KHGhYoEi5S+J5H6E7UMyOxIIo
          iqYpsWKL/+hgfbi1aQCTJdQhZVWX6Irm3WfD6ULgUdJnAXqbaBJCZGHroukBc9in
          zrbNHkhxMkDte353j9lUssne+lRL7ZeMLDi9NJx5QezotorXEGsL1br0IvB6VbNj
          /NfC79NQpjLQiejuhbI0JX+SUGkV0WDBVf4FI2BY1lEFO/8up//rrg==
          =yY6d
          -----END PGP MESSAGE-----
        pubkey: A8U8GemRw8rorCWl51RWUU7F5zwHtzPuqB4JBSF+/EE=

    mobile:
      protos:
        - babel
      as: 4242420101
      domains:
        - dn42
      netdev: x.mobile
      wireguard:
        privkey: |
          -----BEGIN PGP MESSAGE-----
          hQEMA0EEvUwCdTjhAQf+NAQxvhgiJLQgXbtHUaQuT3DZbFz66Zx6I00rM6TosW4H
          nsxRP4a3X8SI0CUcwaKrgZd449t7jcofanHBZTld3uENJClPvbTB1fNfzZ/esDiy
          cP1XJZQxH94shyFfzoc3uxuxMquEehh4wGZZNMzLGef3vQtRdhE6kr7X8xtNriyW
          lUUjkBKVFRriv45xV+V5tRBHZHXpd978kzdRKoSFbgRyk7EQFrWQdqyuKKhyA8D/
          nUgCml1fFOvrv7uhr8vD8Di5UqR2ox3pWZnz/krUGV/s+wmC452q1iKOk4CAI6rZ
          Q2MnYLVoRUqJJAcxTXSnNOKTEu7eqOPLl02yfyeTzdJnAVde8V3gVXOuf1mEf28X
          X+oOH8VOdbGenwWHPO6fZDWBTr+2ENG8f2Rck2nyEjnoGMkZA0JyPpSoeb2zrl36
          5epW3Lg9kH1U0p6a4aYTU2zSr9r0sSEkiL/DOb2c6X5tepXtiRYHWA==
          =/JBC
          -----END PGP MESSAGE-----
        pubkey: WfD2PN1bicE/OsK+jzHSxePvRW0zYKAH4WDYUBiEUhM=

  transfers:
    north-zitadelle:
      major:
        proto: gre6
        ip4:
          local: '172.20.240.150'
          remote: '172.20.240.149'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      cccda:
        proto: wireguard
        wireguard:
          port:
            local: 23420
            remote: 43007
        ip4:
          local: '172.20.253.25'
          remote: '172.20.253.24'
        ip6:
          local: 'fd5a:ad49:84cc::253:24:2'
          remote: 'fd5a:ad49:84cc::253:24:1'
      jojo:
        proto: gre6
        ip4:
          local: '172.20.193.21'
          remote: '172.20.193.20'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      maglab:
        proto: wireguard
        wireguard:
          port:
            local: 23421
            remote: 42001
        ip4:
          local: '192.168.234.1'
          remote: '192.168.234.0'
        ip6:
          local: 'fe80:42::2'
          remote: 'fe80:42::1'
      south-zitadelle:
        proto: wireguard
        wireguard:
          port:
            local: 23231
            remote: 23231
        ip4:
          local: '192.168.67.0'
          remote: '192.168.67.1'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      bunker:
        proto: wireguard
        wireguard:
          port:
            local: 23232
            remote: 23232
        ip4:
          local: '192.168.67.4'
          remote: '192.168.67.5'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      router:
        proto: wireguard
        wireguard:
          port:
            local: 23230
          psk: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf+JWnBRLs1GsRaGroCEroeh6KfdnlyfbbFog3uS5rwu2yL
            PPQOJ4VtIzPeomRj9omI2rdihoA436S742T6DFRQt6/J5XYqHbeZFRWziQIP+Dnq
            GAloTOc8Rf4KX9GKXhcmkntjvktPJE9DQ2j2GIhyA2TGwxR8foqpdl/BV1XQMyVm
            8awhnNNRidJDSrFg2USsjGTWkcLp/IKupvHuIpLMS8HcrWaHMC2CAPSJWAs31BVd
            Ld2w76xh6vmyerGyyAEwlY704ME5+ddBeGS8Iy93dj6u3RViaFIzmoaybovFVlaY
            hnWyPx/YHV/WyExRJgv3gjPff9XUkJ8Vqr6xKfhBnNJnAf/QK9A755Me4EA3lGPC
            GeM5/t26QluM887/5RF9DBUcd75bvSg/iswyWkoEUq2qRGQcffzYwd3q6yr8hnDZ
            R/LZvO0iPqz6WsboTM1yh3wRdlErOwab/ufx5ThOMGQGQD18iclFAQ==
            =BC6u
            -----END PGP MESSAGE-----
        ip4:
          local: '192.168.67.6'
          remote: '192.168.67.7'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      mobile:
        proto: wireguard
        wireguard:
          port:
            local: 23422
        ip4:
          local: 192.168.67.254
          remote: 192.168.67.255
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
    south-zitadelle:
      major:
        proto: gre6
        ip4:
          local: '1.2.3.4'
          remote: '1.2.3.5'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      cccda:
        proto: wireguard
        wireguard:
          port:
            local: 23420
            remote: 43009
        ip4:
          local: '172.20.253.29'
          remote: '172.20.253.28'
        ip6:
          local: 'fd5a:ad49:84cc::253:28:2'
          remote: 'fd5a:ad49:84cc::253:28:1'
      jojo:
        proto: gre6
        ip4:
          local: '172.20.193.23'
          remote: '172.20.193.22'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      maglab:
        proto: wireguard
        wireguard:
          port:
            local: 23421
            remote: 42002
        ip4:
          local: '192.168.234.3'
          remote: '192.168.234.2'
        ip6:
          local: 'fe80:42::2'
          remote: 'fe80:42::1'
      north-zitadelle:
        proto: wireguard
        wireguard:
          port:
            local: 23231
            remote: 23231
        ip4:
          local: '192.168.67.1'
          remote: '192.168.67.0'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      bunker:
        proto: wireguard
        wireguard:
          port:
            local: 23233
            remote: 23233
        ip4:
          local: '192.168.67.2'
          remote: '192.168.67.3'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      router:
        proto: wireguard
        wireguard:
          port: 
            local: 23230
          psk: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQgAq1AHHiisiNOI8lvfT8XvwyeZ49mb1Ug7S63GU7HJCCy+
            3ajqHgoRgLfSPizEDcfGPilILEo72RuOtpKDvaDvSRXTa61PfBQxo+wn3o0/ukp6
            8OFexXsDgUssBgGVCJt49JtxfdtqRma60cEQi1IOqjJMU4U9ZaogpR4ZEXjbWXHp
            hf1w/OSE/uOdBSFPHxzOrpd5ABpAE6pvRj2QvuJZ703N1dm1rlyAgX2k5k6fsqyh
            4NVpdVNEtBxlCpfSKzVvy+5qLbVHGwJ0EUnNf0CLQTTUgWq0zp9YH//UZm1XvF0p
            J6BMealX3WGFSeh3PM8UQVqliQWfvFrSPolDfvoFHNJnASZq1OO0ei9jh+0dUzB4
            01viYTlZBz/DupAAcwMQx3D31/QVFt5cgLcKA6Xdo667uRhKYwZHNUpzAhckcb94
            QNvYK69kSy4+0iQ4SQ/2By1wPcGdkwuCcqwg7sKrhsJn9XVXFftzsA==
            =H8CA
            -----END PGP MESSAGE-----
        ip4:
          local: '192.168.67.8'
          remote: '192.168.67.9'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      mobile:
        proto: wireguard
        wireguard:
          port:
            local: 23422
        ip4:
          local: 192.168.67.252
          remote: 192.168.67.253
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
    bunker:
      north-zitadelle:
        proto: wireguard
        wireguard:
          port:
            local: 23232
            remote: 23232
        ip4:
          local: '192.168.67.5'
          remote: '192.168.67.4'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      south-zitadelle:
        proto: wireguard
        wireguard:
          port:
            local: 23233
            remote: 23233
        ip4:
          local: '192.168.67.3'
          remote: '192.168.67.2'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      router:
        proto: wireguard
        wireguard:
          port:
            local: 23230
          psk: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQgAz8tssmmRbq1I6Gjo3LmD25T1bwvAmSxfGIGDrzsWMuus
            7meHHGYqFeWErXOunYq7BJA2VSC5VBhE3+YBq+LdPYfaAGNKXolyrbJmbcQVser4
            d0DTq5IaYz5M05TEE7plYltaqQsdXpG+g+RA43pAno1EIkH9X3E9qgUsCju9Ezry
            LeywW0ePeJaV6uJpSLTso1DFGebyYff6a0eNXD3/kzIZoPmmVLGe1WTSqK7ztF0h
            fduWrUkpi/dvZa1eHE4H/Zqwy+LmcRoRU57BcmNsq87qKv64iOkwWqR5DTDVqPR9
            g1idulz7KwFI8aeaM/xz9quD1aQAaGewQFTOkeQY5NJnAb+nVnC8h9g+toG/Mq4b
            xFvvtzWdChSLtIdF1YRbN2MJzQ4SrQA0SQdufM9JVq/nMOnjVyMmfMS8fUorwiAV
            abhFl5bvXNzTonPa9kcxL+mdlC+3r/EogSPKrUQHuJkRbD6BsEkFtA==
            =cIU2
            -----END PGP MESSAGE-----
        ip4:
          local: '192.168.67.10'
          remote: '192.168.67.11'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
    router:
      north-zitadelle:
        proto: wireguard
        wireguard:
          port:
            local: 23230
            remote: 23230
          psk: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf+JWnBRLs1GsRaGroCEroeh6KfdnlyfbbFog3uS5rwu2yL
            PPQOJ4VtIzPeomRj9omI2rdihoA436S742T6DFRQt6/J5XYqHbeZFRWziQIP+Dnq
            GAloTOc8Rf4KX9GKXhcmkntjvktPJE9DQ2j2GIhyA2TGwxR8foqpdl/BV1XQMyVm
            8awhnNNRidJDSrFg2USsjGTWkcLp/IKupvHuIpLMS8HcrWaHMC2CAPSJWAs31BVd
            Ld2w76xh6vmyerGyyAEwlY704ME5+ddBeGS8Iy93dj6u3RViaFIzmoaybovFVlaY
            hnWyPx/YHV/WyExRJgv3gjPff9XUkJ8Vqr6xKfhBnNJnAf/QK9A755Me4EA3lGPC
            GeM5/t26QluM887/5RF9DBUcd75bvSg/iswyWkoEUq2qRGQcffzYwd3q6yr8hnDZ
            R/LZvO0iPqz6WsboTM1yh3wRdlErOwab/ufx5ThOMGQGQD18iclFAQ==
            =BC6u
            -----END PGP MESSAGE-----
        ip4:
          local: '192.168.67.7'
          remote: '192.168.67.6'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      south-zitadelle:
        proto: wireguard
        wireguard:
          port:
            local: 23231
            remote: 23230
          psk: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQgAq1AHHiisiNOI8lvfT8XvwyeZ49mb1Ug7S63GU7HJCCy+
            3ajqHgoRgLfSPizEDcfGPilILEo72RuOtpKDvaDvSRXTa61PfBQxo+wn3o0/ukp6
            8OFexXsDgUssBgGVCJt49JtxfdtqRma60cEQi1IOqjJMU4U9ZaogpR4ZEXjbWXHp
            hf1w/OSE/uOdBSFPHxzOrpd5ABpAE6pvRj2QvuJZ703N1dm1rlyAgX2k5k6fsqyh
            4NVpdVNEtBxlCpfSKzVvy+5qLbVHGwJ0EUnNf0CLQTTUgWq0zp9YH//UZm1XvF0p
            J6BMealX3WGFSeh3PM8UQVqliQWfvFrSPolDfvoFHNJnASZq1OO0ei9jh+0dUzB4
            01viYTlZBz/DupAAcwMQx3D31/QVFt5cgLcKA6Xdo667uRhKYwZHNUpzAhckcb94
            QNvYK69kSy4+0iQ4SQ/2By1wPcGdkwuCcqwg7sKrhsJn9XVXFftzsA==
            =H8CA
            -----END PGP MESSAGE-----
        ip4:
          local: '192.168.67.9'
          remote: '192.168.67.8'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      bunker:
        proto: wireguard
        wireguard:
          port:
            local: 23232
            remote: 23230
          psk: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQgAz8tssmmRbq1I6Gjo3LmD25T1bwvAmSxfGIGDrzsWMuus
            7meHHGYqFeWErXOunYq7BJA2VSC5VBhE3+YBq+LdPYfaAGNKXolyrbJmbcQVser4
            d0DTq5IaYz5M05TEE7plYltaqQsdXpG+g+RA43pAno1EIkH9X3E9qgUsCju9Ezry
            LeywW0ePeJaV6uJpSLTso1DFGebyYff6a0eNXD3/kzIZoPmmVLGe1WTSqK7ztF0h
            fduWrUkpi/dvZa1eHE4H/Zqwy+LmcRoRU57BcmNsq87qKv64iOkwWqR5DTDVqPR9
            g1idulz7KwFI8aeaM/xz9quD1aQAaGewQFTOkeQY5NJnAb+nVnC8h9g+toG/Mq4b
            xFvvtzWdChSLtIdF1YRbN2MJzQ4SrQA0SQdufM9JVq/nMOnjVyMmfMS8fUorwiAV
            abhFl5bvXNzTonPa9kcxL+mdlC+3r/EogSPKrUQHuJkRbD6BsEkFtA==
            =cIU2
            -----END PGP MESSAGE-----
        ip4:
          local: '192.168.67.11'
          remote: '192.168.67.10'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'

