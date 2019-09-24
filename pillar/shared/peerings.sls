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
        roa:
          ip4: '/var/lib/bird/roa_dn42_4.conf'
          ip6: '/var/lib/bird/roa_dn42_6.conf'
      babel:
      exports:
        ip4:
          - 172.23.200.0/24
        ip6:
          - fd79:300d:6056::/48
      filters:
        ip4:
          - 172.20.0.0/14{21,29} # dn42
          - 172.20.0.0/24{28,32} # dn42 Anycast
          - 172.21.0.0/24{28,32} # dn42 Anycast
          - 172.22.0.0/24{28,32} # dn42 Anycast
          - 172.23.0.0/24{28,32} # dn42 Anycast
          - 172.31.0.0/16+       # ChaosVPN
          - 10.100.0.0/14+       # ChaosVPN
          - 10.0.0.0/8+          # Freifunk
        ip6:
          - fc00::/7{44,64}      # ULAs

  peers:
    major1:
      protos:
        - bgp
      as: 4242422600
      domains:
        - dn42
      netdev: major1
      remote: '193.239.104.101'

    major2:
      protos:
        - bgp
      as: 4242422600
      domains:
        - dn42
      netdev: major2
      remote: '193.239.104.103'

    cccda:
      protos:
        - bgp
      as: 4242420101
      domains:
        - dn42
      netdev: cccda
      remote: 'core1.darmstadt.ccc.de'

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

    ffffm:
      protos:
        - bgp
      as: 65026
      domains:
        - dn42
      netdev: ffffm
      remote: 'icvpn2.aixit.off.de.ffffm.net'

    maglab:
      protos:
        - bgp
      as: 4242422800
      domains:
        - dn42
      netdev: maglab
      remote: 'lintillas.maglab.space'

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

    bunker:
      router_id: 0x3d44ba3c
      protos:
        - ospf
      domains:
        - hive
      netdev: x.bunker
      remote: '37.120.161.15'

    router:
      router_id: 0x4364370d
      protos:
        - babel
      domains:
        - dn42
      netdev: x.router

    mobile:
      protos:
        - babel
      as: 4242420101
      domains:
        - dn42
      netdev: x.mobile

  transfers:
    north-zitadelle:
      major1:
        proto: wireguard
        wireguard:
          port:
            local: 23423
            remote: 42101
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQgAzl2zHxzOFJ+h20OoYZ2MMgi/sP++bs7GUw0Ki2aeOJ/5
            CPA0m/16sYJQw+S2zsUtiVdFtQlL8HJbhylx1h6dHnQCPB5+9Zu6yg1wjGZjjVgy
            UjFhF/fHGy0FinIx+fEw7DRMvL/dnQlCFjFR+y0NByG+5rfJ4j2rOjt//JpCP/HK
            wRRimXtnXWi1aj8m/JW4YDrUWjHFG6c2TIHmlLmiRATXBKkgf3Ws4/1uUePKr8/A
            YoJ3ePb1cpOMbT8/cgTUD+lp41UQEi8PX0n6jzGaw6dvDIwEp0vNL3gR7hBS3E6d
            A922Afu6gWSZooKKfBg910EaT+FkQfhKFlvXx1JYvdJnAcExpGKjCngVsmskl8ww
            XDyZb1r0GpZhr5p7qBA5xYtQs5vP4yZ9+5Lg96hnly/xM+q0VEvjbGsbA4fq5kVV
            Xak4eXucbCrWw1lu1kt4CjtxJ5tbIXs33gBf7Uj4oDCFLUqGxQwDmQ==
            =vYXf
            -----END PGP MESSAGE-----
          pubkey: RQ1nOR6CeUHuLOg8QoZHGPWVN8yY/HYhHC3KKfzZ5H4=
        ip4:
          local: '169.254.42.1'
          remote: '169.254.42.0'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      major2:
        proto: wireguard
        wireguard:
          port:
            local: 23424
            remote: 42101
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQgAh0kp/wWB3iiLDQ/hgEiA6zf4YsczPpS4NreFyO7G8A1p
            Yv6GO9DxQdf7htnztsvHx4e1o9v1t4R8PSe3FC+PJ7zLFjyBXZGvxp9oVp5cw7nU
            6qEOVHDdVIxtxa59hnN+HQJtDe0+fH3b1DiYkwiBRkc5Z0zULmjhRsuDnv58MufC
            tYUW49as9tpRQOVx3lksTlSW6qVGwRPJEtxfEj9UairC9MwW6o8Ionpzfj3ZRjfI
            5zyIYi5Hy0bUGxOFkcgnQB8TE8bkEMUhsGU4pvT8SBG0fLtCtW9TgDn1Bndka9wU
            fm/QDCEhtVoK6Jh4ahmJiZjePTBCrDK7GeVA/Mr4vdJnAeX4qT/TxK5uGpplZG9D
            u/ffP8AY4USCwmJWZEVkJjqOET3COzY3IK8zIQu/70Xwb+Rn/zdkgo7s99kdC8i7
            GAiJNmLrZOutpFtu4m1hyDYhl2vyYJBzHpIjGBflRHYpKqyKAUY7zQ==
            =zuVq
            -----END PGP MESSAGE-----
          pubkey: 9otCYTT2Eg+W5s3jEIXyVnclGAY/fOpcf21IOMH/VWI=
        ip4:
          local: '169.254.42.5'
          remote: '169.254.42.4'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      cccda:
        proto: wireguard
        wireguard:
          port:
            local: 23420
            remote: 43007
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
          pubkey: B9v1EHhXAoCNbF8WZQe3Tdrm2GhvHZi6b59a/xlpESA=
        ip4:
          local: '172.20.253.25'
          remote: '172.20.253.24'
        ip6:
          local: 'fd5a:ad49:84cc::253:24:2'
          remote: 'fd5a:ad49:84cc::253:24:1'
      ffffm:
        proto: wireguard
        wireguard:
          port:
            local: 23422
            remote: 40106
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQgAnfC2A8IN3zCevX0FKrdQsTB64CtIIXQi7GguWejrCeH5
            HTwHPVmoqFt3mlZ2v22JN846V7IrPsdcuTjv/fpkmlEAzSt9R2Hfo5uuM3HA/JgJ
            29zmZvQhzPQmtLhm85IuxqpGKBZHGRLACh1skpgRANSp54/XkMqDJkd0etg4Dm1z
            f8EZ4THAYfpRD+GdD4vkTbkjOxmErCX+ao4JYPQOUNpoyVpG5xL2id+tQUBBxC7J
            g2DcQJAWkfDMKSyxMMLq2hpvbX4S8B12cfsCKnHXlHk9fCCQPwwqFPaLz5ccBTbn
            Bn8UwYjvQ1qLRN93PTEzlRIMq6t0Go1fm2XXL3c649JnAZmKAhgBxhVmsDpptmjx
            kKHHhUa2BQ2p974ANFFqbE5Yc0Tg7/dp0dIAjSKQD0JdyMA3WJNgCeAqhNCVPuaW
            TPta1vNJW8l6iqNy3oxTBTFr11Qfl+x14Zk0cNd+AEL+Pw/H1Z1pxA==
            =3FEz
            -----END PGP MESSAGE-----
          pubkey: W7M6vBlS7yCaV6q1Z951ebAnb1POzFOZth2Ryr8qZxw=
        ip4:
          local: '192.168.237.1'
          remote: '192.168.237.0'
        ip6:
          local: 'fd74:f175:7a21:4f22::1'
          remote: 'fd74:f175:7a21:4f22::0'
      maglab:
        proto: wireguard
        wireguard:
          port:
            local: 23421
            remote: 42005
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQgApwsd20W4rSAP8aY3ZCDd9FLv15tMGp3krlTuK/zXydLL
            aI3YPPL3AHS17U5X+YxC0Fw0jrC3E0PDcPxYNtm2JC50qFhCGmF6n6enR45SCxct
            faaYhuOZMgBQpN54R+5WVpYmtYylh4H+FLCIt/nky99CM25nkclyKH9q68XYzcbX
            nLC6P6Fj8Xt2UrQ7qjBJio4G7Apj4AAL2AXVcrDRBY3TgWCBKFHWvNeHpuBXMcwq
            pY+bKnE5+QhKLsPfksBCJxXXEI1fQPvx+NrA9RzAPv0rSyQDw9fO98b9r6bUZ+ED
            R7ECi/kXUac33zIZIQHG/HxA00RMlBzxOt+HF+81eNJnAVoUbdOh/Il1q0P2u5iJ
            OTL9Vkn96MuOJBXgkLyYHndzsLUBwptAkmZwPrxFkA0WfpPZiFwokE1S06nFFYO2
            2YU3w56K3y41KU9wGAcQzqBqAhBlIvBLhM1yMCO5p2DBQLc5ww2qGA==
            =dl10
            -----END PGP MESSAGE-----
          pubkey: mTOnizd4uUjUqoMP1WiJdR/LeqyeIc3d+3dJnO5Z5yE=
        ip4:
          local: '192.168.234.5'
          remote: '192.168.234.4'
        ip6:
          local: 'fe80:42::2'
          remote: 'fe80:42::1'
      south-zitadelle:
        proto: wireguard
        wireguard:
          port:
            local: 23231
            remote: 23231
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf/SfO1ImkB7VKsLzhZ9YT5oAKFopeErPJU7TJZ/1g+PmCB
            VGLqvk+/NsDORHJx/KjGvBbvYOEEbEZ5QwKG3ABIK5wSrJnQj8eQ4BeH+dEP80D2
            7PBR9kZquXUzDtRmPV40Qj2qkrMimI5KH36wTXENMSLvx7UzWBTIvhq/pBQS+kzJ
            dlzTvoQvOTETW26qHfxER6XE1WMuAPcTOGF0Jg4ynDWpID5aOYJ4IvaYrqDXbeAL
            rCHOgc0mEEjr2tVeO//Z49597uYcRBaOUuNfAvLd7Hgjl/078lTmFRcjHbfcJKKo
            s2oQRa8I7mabUGbNgTEQ6WeAX3byx8nhcyH4qfZWlNJoAVenJPz2oYfNI2YVf0S2
            ikfB099rD2EhURhEDTTGbbmGcs/ddj64VWhnXFRQTMjbEskK+pW04bfJYayVvplG
            13g4D8nXsDYpJI0/oFsUSx0riAKXcf5oZOK3sTKr66pN8syjr4CyI3M=
            =uR8b
            -----END PGP MESSAGE-----
          pubkey: hHHLKncOmCt4yC6k4Aemr9myDy0wex5pwPUyDS76Xxc=
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
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQELA0EEvUwCdTjhAQf4zYNHd3p7O/wRruB2smTZXWoFd6G7VE3OTSRfwsi0QyIR
            AVBPGktvo5U9VkGtNveqJXMbuzeDZQGj7JEZFJDNyAPKkSCKkfBViZTsWxsP861E
            xTG6N3YhiA73sSYd29BNQHeX1JK+eCUKys63BC+ZMgxNG81A5cXD0694zAsFrqxD
            fAswR/N9Ar+hovjk3XyakTkp42xjKZAXHxbtBurTbxkVKxk+G7gk7Tgn+FFCRXBJ
            kil4fQGJZsRS5SKZ4Z6Lj4pfntg8q8iblhbH3lJ5UIpGUQYxriNwE2E4c1V27PQU
            G/EaQ5yarc0+lms7xk87LfrR6dGcvK6MLxEFHFxR0mgBopkBbPKwXvM2ouRMDa4y
            4WboMvaVFhAdNyvPP0muTxRFPuH2IBdRmqx4So9dukxIQeKWuxzDD1w72uTa6GOj
            1mVaQBDdjVGm77EcnIpD0mEhrs5di5t5ebcDbf/IcqoHOG2wLcm3ug==
            =Al7Y
            -----END PGP MESSAGE-----
          pubkey: aQItCAPkPHpJ7QOINT1pGt7pM6/5BsyhclYdzjRhiCM=
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
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf/XYlYv0PUG8XEMRxtbQJNpn7m3z9Jm4KCsLivS8YINPHg
            7XLJlW1MtXDjhGE+yr5mvvrqIq0IXAXJ7qoH4ODxZecNpVif67REYLZjgaC6/RY7
            Of+lDVxzIsoMSvbRwkcSwp8KHKI4oad5e3ViPkDSNLwqm+xo7YJuk9dUQAJrzw53
            1yf3yeZpX6LG+IHj0HMMKkxa9J4yrT+QWA19IfPVi1kTeocY58+jOqwmcfth4LYQ
            epjJNcpg14G/AeNj7YMihne5WDBWzW4QH5zemZwdD9ylUSkSmRczAIzS+Spf7H/c
            cqOr+aOgMKTvEesSr820hlB3hLasm4hxWm18Dd6v1tJoAdrHHEmUPW1omy7PWwQp
            YY5a2D7wtMtAZ0Ra8or775pQQwGwrcj4QLj1jJ9YPuK7IEAIdNmbeJfspEicQR3W
            Vn5T2E3Vg1Tx+vb2LAtdMhT1q6U2sCgt/g9yRcg0XlOw/X9r0nEh6oY=
            =qep1
            -----END PGP MESSAGE-----
          pubkey: PPtiPKtaC17nzlKX78xJ6NJvRGucD26HsTtsnZlerRQ=
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
            local: 23239
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf/cOkBqELrAoZiEX+5OpN5OLvzVeO/ng+j4tHZEEhg5e29
            EP1zqKV3BfJ+cmgNJXuq+PgUpkrAhs+ShVTyQWTarSK+C8QS+nGrruxnbPDWfnt7
            mS5V9ZrKq1n2JMQrIKpmhfa7vz6HKoTg58onMwk13XqFuLBciC9VZT8h9BR6lHIk
            IqDE8EKCG3AEZQwvZN0P+my0L7HoD4ERVEaBmtwWcEQDIyDbwGu1V6KBqzEShD00
            bDO4Xl987CROQvN+pREUr0lQNP5EMpFqQSEvNsXPyc8O4InrM94SnP7QZYsK2jBM
            idUauG9uQIop/3Gb1txRQv3oRoxGM+O255TX7zTdLtJoAXpdWRjEPHCyXpJnVFfm
            6JrNPUnKFsq5zEjCNnC2fUYOV/oHp7XZU/LjyjcHRN25fwkfCLJVzceWDSookn5O
            aIBKHP6b9gLt9y5I8KsqwlYWarJzE/RazNr7OIOj8gj/8P10sgi6URs=
            =B1Nv
            -----END PGP MESSAGE-----
          pubkey: dj9ooKzq0dFJIxnt6BKJ5Qz0akg0E44BXVbrQL0GHCs=
        ip4:
          local: 192.168.67.254
          remote: 192.168.67.255
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'

    south-zitadelle:
      major1:
        proto: wireguard
        wireguard:
          port:
            local: 23423
            remote: 42102
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf/RQYz7gLC0Z0cQ+rVYRufz2opjJxMpxSI2AimvvsdJK7l
            euVJRJeCPy8RMhAv9szZ9qsaB4KUExdmGEY5xd+uF19lrqAQqG+mOoEW1gA44WH9
            QiTj3XrDINPUb4IQt479e5BeA+GH4lXR4wh4CFprDzgYSaqrvupTZ8scSfGIFcTw
            hm/Av0Lw1SrsRVa9cJOsXCdTqS6qA0PZApazBFdvP46uYOwWVDkyU88EI5vQLRns
            PHG30LemPvwjC/h6w+n7fqyjKiMWqEAG2IzlwsB6RmckzkySsWup0/TPXeto+UDq
            tpcd/QSZuHJVOST4KMfEPUI/t5hIs2joHcaEHR7qWdJnASJLblmedb1NkGcRtVKt
            Ln16g4rEisTsJtsmTwGi3YrDPBVh7otrjCdOe6cl7iqravX9T3hSZkrgT1M3NMzd
            5iaQrTflG/2Yb+CcbukAMCcSuOz8Ggwc6ODrSCVWKZWLPHkrCk8kGA==
            =xJY4
            -----END PGP MESSAGE-----
          pubkey: 2TUO7Aml21ppyciumxBukZyjO+YkHyFP087mu4MbRDY=
        ip4:
          local: '169.254.42.3'
          remote: '169.254.42.2'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      major2:
        proto: wireguard
        wireguard:
          port:
            local: 23424
            remote: 42102
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf/dlAuVGuHeSSy3tGy60W1Ybpb6j4UAjbfDyTZxb4/6e+4
            d7/xhUcHgYMStCheYZiKfUEXHh8OspkzWb06hheuTApxDy4qvhaXyDOS5IWfV1m4
            DQ+ivOaAW/6Ga/kT46J0zoK0ATAy+EN/ty/BRu1d1wW0ClzrHHf12wJBO7cJFIPu
            ZWhGFAPkp+Ct4NlSUlOF34XTvODdZQQVRmz4rgWq39LcAgymdgDkESNVEsByl1Yd
            kg02qh9lgD3RXF3IJG7gJzKHjRzwE8gwr1dFFWdRzoq6JgGkXVwLU7Cgyy7gbJ2n
            tSESRO+FPHzJpyJn8nBBh82pnHy7dqBfwER07aLSwtJnAWeESp5jUxv5/ALlK23s
            G680okpmFf9E9SINa92uTjfu357VwwfyPzncjf6l7roWo0bwfOe5C2SciMXka0ja
            Y1s+EY7xT8Y+VhuZ2WXXvkwRFq+ZLJW+M0/MZx9ToMVzbsYOxzNQHA==
            =kHQ1
            -----END PGP MESSAGE-----
          pubkey: ebhr1DqDTfitH3XlZCT7j6DnEXP1+Ax3krei9CzNICo=
        ip4:
          local: '169.254.42.7'
          remote: '169.254.42.6'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      cccda:
        proto: wireguard
        wireguard:
          port:
            local: 23420
            remote: 43009
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
          pubkey: B9v1EHhXAoCNbF8WZQe3Tdrm2GhvHZi6b59a/xlpESA=
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
      ffffm:
        proto: wireguard
        wireguard:
          port:
            local: 23422
            remote: 40107
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQgAnfC2A8IN3zCevX0FKrdQsTB64CtIIXQi7GguWejrCeH5
            HTwHPVmoqFt3mlZ2v22JN846V7IrPsdcuTjv/fpkmlEAzSt9R2Hfo5uuM3HA/JgJ
            29zmZvQhzPQmtLhm85IuxqpGKBZHGRLACh1skpgRANSp54/XkMqDJkd0etg4Dm1z
            f8EZ4THAYfpRD+GdD4vkTbkjOxmErCX+ao4JYPQOUNpoyVpG5xL2id+tQUBBxC7J
            g2DcQJAWkfDMKSyxMMLq2hpvbX4S8B12cfsCKnHXlHk9fCCQPwwqFPaLz5ccBTbn
            Bn8UwYjvQ1qLRN93PTEzlRIMq6t0Go1fm2XXL3c649JnAZmKAhgBxhVmsDpptmjx
            kKHHhUa2BQ2p974ANFFqbE5Yc0Tg7/dp0dIAjSKQD0JdyMA3WJNgCeAqhNCVPuaW
            TPta1vNJW8l6iqNy3oxTBTFr11Qfl+x14Zk0cNd+AEL+Pw/H1Z1pxA==
            =3FEz
            -----END PGP MESSAGE-----
          pubkey: e8z+pYfwLdj3yEThh7etkOnkwRu/4HOmKNoT0GAVZjg=
        ip4:
          local: '192.168.237.3'
          remote: '192.168.237.2'
        ip6:
          local: 'fd74:f175:7a21:4f22::3'
          remote: 'fd74:f175:7a21:4f22::2'
      maglab:
        proto: wireguard
        wireguard:
          port:
            local: 23421
            remote: 42006
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf/TuuCLiKp+8LLiHrOxRmt2OpSJbZSlhI0ZP3ejjpNESOK
            RUf9PkvcT5DvnL0GCDFWwzxXuQN1CsjAUwDYu7aoHA1BRezZgaawt+SpIaIkgy4m
            6/tYnRiidcnHbdQiGuNiPB0Jeg13W8JRtJfSX+2g/6l6YnQb7f48ssx6Ppbu9OGp
            s1pcX4gSub5fYh5APUSa1CzJCE44/kLGModwyNLoykAoWxjUgtx3ei0qlldm20oW
            ZOsqlQKzRY+92ukuLS5Z0xRyVo4zB0osnAidPZXYkctQbmrkWcRBZXZqlnzR3lRv
            1IdAb5ISe5SqnryyxyzOrB8lfalleU4IEvx90PKjWdJnAaIvqgGPWHPpPnsNvQah
            evsevV6YPVg5X+1dnum1qWipptvVi1l5SidrhdDBou+UpS8r+JJLNtNHmMTdDhFU
            5CYUbdTSukWUPgBxjzIEGcTilJ7JcV8+m8xpvgPxw48n3kgRaTS5NQ==
            =fFkP
            -----END PGP MESSAGE-----
          pubkey: wKN9BrkkKv884EBifkMMlwy96PADSOvaM9g5kM+Ub10=
        ip4:
          local: '192.168.234.7'
          remote: '192.168.234.6'
        ip6:
          local: 'fe80:42::2'
          remote: 'fe80:42::1'
      north-zitadelle:
        proto: wireguard
        wireguard:
          port:
            local: 23231
            remote: 23231
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf/T2VKR+83CGRezBezva5buns5/18kXvD5961UNwm9MZXB
            X2m3Ms+mHIppqXnsWxzLZDvHrcfYVjLkoIYz5Hi6pRJEs1ITrM69VYswGw8TTaSg
            uA39EICCOzMdFUbgg8vleuvdRsVNU0CEsY4iywQk9kAIwc1H60RP4Q8nQYYWfsU3
            M5W3UdrCwenQh3HURnCCtFN5pDiawRrBKfbfHO2nYzMw8qbaYIJTL9O7cA+lDE/g
            h70vwfr0u/P3x2Y8pNSKP531CL1FEM/T+beEc+H+qGIc8euqC4hbvCR45TOuMrcO
            wA7gAoU8bcXjPa8OUx7OAhTabPECqh4AqjocRNE+UdJoASpmN/0nT/gVaT6PelTA
            NOX6rQri/bMnPkRqOGT3isPKDak0gwP6e/sLWOP8ASy5Ta9rhoMOI5P8C8X0u5rh
            E+BnN1I+azC/SClk4bby50MfLxhSr/t/jZ4sEWYhPPXTXy1j8sotTLQ=
            =8Pi9
            -----END PGP MESSAGE-----
          pubkey: D2Bk4/meVaDz9q/ks775s0Fbqb0ky35auPMVT1r2Rk4=
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
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQgAthLPxAVcNB+vrR3qYKbz5EnmdrFyt+yOlV5+qnkmo05C
            +wjWJv8ZmtNInfqtaCbyYNiWq1gjsSQ7bZN1BJmkexWcD5pa0zxKQLCVLlYBwoZg
            axsynPVCLXa01XSF1fz/C72BYKv3BgaC6poM4qcx97Wb3phXdT1Kgw31P1YJbgr3
            BwbUNNBzRu6zh9XdH1nQqKp8ccOD8fpsFu9UXTya7pJwwcWMFDDs/Z+lpENSAGNC
            v7/Z6lGqOccqBQVc7NUKQO4rFQq2GCAr5QhUiKp8Qw/QxrnnlL1E9I/NdGXMsqFf
            4HS8+2zuLRAPOKu0uh2sdcFA9XAPHMtYtV0szGWhm9JoAZSejz+gMfhOj8muWM8K
            d+iWKHwokKHJDbhOKsVMKVwOuMEuN8GmIXOZZHVzBwopyOiGjnhFttKJt4wExt30
            49b0IIhiTLlUKYaNVJBIbFKNw5CIEiMcvXYCHrRRK5DBgaVerTA+oEk=
            =y/xm
            -----END PGP MESSAGE-----
          pubkey: HAJYxD3QNWcSelGaT/H3vssR5wAB1WZlU5rhi7Y/kjU=
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
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf6ArVP7O8kNmdQuomtH+iHG9quVz/6UV9XpogmEAAp3t2x
            3fNcpHPh9Zh8R3HEUDI1rILlLkRLqW8f3e8/bWWFXcwursjCBVpZTagfJkun2q68
            Qf3EhQrU06D+MAj+rp/SY/gMp4R8NxAXkbPThx/IovxF02ij8DP3zUb/CwC34Gkp
            X431DcwXvaTMOKS75zcYbtATQD3U+J+gK3MUAuOkJPzqF4gJ3/Dsm2AlL5cii/Kw
            UuBJdl3Hdw+PmkOP/mImgo97nLg2v4O7FSF7fz1EDViuGGgscflcanF9XaNYIpwC
            89sh+1Ycbp5vc8UQ+JnqA0W97JCXIECO4Xrn3ujSt9JoAUZYMyZRCMqUTUlw3J09
            OMZA6Co3IWEPmn7u2Kw9mIozLkojM7KG1Y2yAd+aHCMg4CmRuPZK6YCIRNFQuT2/
            gb1+z50DvTpQtCJshpGi0+uSyI0Myu7YLLVfFx+foXjt7dqcZAKjqMc=
            =hCBA
            -----END PGP MESSAGE-----
          pubkey: ejIBvDNi/obUXRABQmQ2INdpFD1+ML4qSmseON4KCVw=
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
            local: 23239
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQgAh0Ta2OyjCPWPtZ14qRn97/+y0so2EqUuNVtbg7/+hPC6
            UhRTfJZIdMzPyoc8ZZ1E9B9NOGZMr8zowzxPB+Y+HJK1yRZNxaeCnB74P4cwLNVa
            tHGNSOq2l1uiNrM2Z7exIwIatKlhfaBqJOn/Y9LeNE7o9ogc58OMBk5Pasj9wDUR
            ZX9UHTRvNpndoJHubdvFCjPrMiyFafaWriGoq5GbjKLPK+g+rDdp7DKFkhhc5yYp
            hRFcDRar+5/ljf9x7OzmidXEqoxPRH3fRsKArh+g8Feq2QzWNxvd1ZEZhankdReH
            1LgOx0IxG5LgNd22L+FTvBNtCEA8OsKPBVFoacWn4tJoAWpByuNa689lzYriUaxu
            Zow+TAcQA46UcNZtDlh+ovbYgQtzSnu3OtF17lhIpuP7MLcv8/VO/dkVpEKKRy5a
            G7Tk3w/IYTRX0LxrvtjF9exNTXRUX9v2Da10L/6AujeabI0zWqDMH5I=
            =/i9M
            -----END PGP MESSAGE-----
          pubkey: iocF4MZa3Q44wxq8ollp4/3Ni+OX0oSLqz+xfAUmly8=
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
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf9EiM+/ifuuD4KTzkDlPPDeCjmaqjb2E7eO2MueK+hfgZS
            fBCWQ65lW5t3rZbEPJGg+4SxajKnQjs7heTORQO6flpYdmf/TCWZm1V2qHKoHtrk
            Glky43knv3ODCbqrny2bhi4o/KTk3NKMTVmewNs3WO8IHWxaKCQ8fNGBubcB2p1H
            YtLsPIUrS6yWqNIZWVkomJ9/1xoF3hkIMqFGufQZDs0/yjYrc0WgSAaE7PPaS9JR
            dwD6avG0YAKNeeo9hpKkBeHMZAgvaCrVBBPTGZflzQPJseKb9e6mXIqd8EgUAZLM
            FL75r7qxcMc4n+9WVFT2uGLBsv6U54Us8rMdgetFOtJoAXWs1V2w+VUkf5v8nZMv
            MEVUE8HgnepFUYW+SI2upHbqvbYDmKsTMiE65SR+yL7ZlHh49zcw8VWCIhGZ/txF
            T/bQ0ZEliqIHEQoxiAA9nEaR/pw8IBSRsH0u2fhg5+CW/lf46x3a1b8=
            =twvD
            -----END PGP MESSAGE-----
          pubkey: RMqnHRdIdLU8sfeh/8Rb2aenclhYjyFwlCGcKkL28gw=
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
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf/dR+Drhu/5N4Y8QQjfHU6E2vmykYVtWvsiZNLLRSW1e91
            maCAWPbsJ/Q4oZ8Dn5+26B2vvAh5Hhgg2gfx5I7C7KHJde212uJsUQybz3qamUdt
            jlYGFBUbkInW9izGuR7VwRTmQmwLlgRS/HPN3sSaaG0o2xZDI/cRxySj80iL2cFR
            sSyLB32a3DLldZbnjktYSqJ3WOtTv3FoJ2L8BSsMVnQv8Qc26pwM9p3nW3iXZ3ZQ
            KzKTAXSsgbOMtprfwSoDQ5WCZxzVE3wNYGJgCouWKmje8Dfe5nm8rUH9MtivLzpv
            NeCQGxXS88yqJIzF3CAoWx9F1+v5pZk0UPGTdegMmNJoAen9FXnymt3pq6AiQAHv
            TIiagD4bKE+vaSpgfaehTnPYPpgQMTyBU7buQ6vYrC0BpQwUInng06TTvUjJr1+k
            iZulirRTkaN4Jz8mLH90RUSINtNRRjcRzHqGeEYUv4dNJkPW98Zrox0=
            =zmWd
            -----END PGP MESSAGE-----
          pubkey: 8SFQts6atZ4GKLuEFKYuwqjKFqkx1UzVCk74iB9htG8=
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
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf+J6q+8G3wY6oxNmlVzg32qQg7FRGR4yqD1v2C52sK5enh
            N3314BWZFRhAp3YmgoPX+8NV/gS8RhD+decJ6GCEguokXFUuDoMhRn0XKRyHm022
            fyk54ogq3TNxXiA9gSsAgs6dEHI8wvUtKL5X2EZU2XJ4I/ERRVO2+KFN7EmkoooQ
            GUD5eWsT/lJ+CSEKD1YxmPAknRaKCmRGqGLokZ1uJdDkYmA9X4oeaDjHHA27Vvg5
            KDcK0KuaIoaENo6lDSmZezE2HQW2WgwiRYUac2NI34YuuqLMt93x7x3ZcKGwN71G
            Ak3kdEMUmZpCwF++6gTNUZi7B6HDUB+D8iUFqnA2BtJoAV7Qg1MfuYe4Sq3AbqJp
            CYL4UfD9EXvcwUYkMAiNiRWwDhwuiuigqfiN8NcYISWdlSIbI2DKfw0dLqjtShis
            /lMHMGp85IphHGgQhCrC67nbGR1b3AhEuKfvY1qBd3+5K92ddNUkh1s=
            =3g+r
            -----END PGP MESSAGE-----
          pubkey: Jsuc9FIBnumQnkP2ipjynBEjmzNZz844CE1BQnUpoQE=
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
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf/UBMqrvZCz1wHpJr2D7NDMWE2SH1xVjSFs8+/Qr8R3fvT
            bGSUgn7UxbgXo9/qjeY1eaRCOK2AhatA1BejrXj8Lhd2IeI5rsN84xPUoVHzJgmW
            I5JBolv0wZi0/DnqkQTXFEVRAfK6GjLThs4TBFN0/3BLRsUyhozgkigj2A8BCXEk
            GKHuJAyizHChDSxbS6/uOUV23Rkr1KRY2LsnAu/NMhGD5jJd7cYZg6P7zmAN1uf0
            /xDiU2PmQ/K08ua5snxG98wGio6QtrXUgPJvCi6xYc5FX8FktIPa67Ry1FgS+5tM
            TbpoPz/5/PT3WV0MSg6mH4X6KAnKY4LEUDdKcQeQD9JoAUTRuTKIi+oMXBrIg9Nk
            94KdGYztRTVoIZPCPMDsWyGyCRYY3XMFBMB93ZZ/93jghw0r5T0HjNUiuSb/wAD+
            g7Qnv3Zx4TrideXtOimNQAUVaIkF+FVvgcVHGGiZVJRZn4xS5tq3iSk=
            =FCJp
            -----END PGP MESSAGE-----
          pubkey: T9YqMKM8Jp+sFvwJN5Y2MV2aWQdIVJ7WhEsKMm9NUmI=
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
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf9F6xYAWcLxmKyjZrdhsUOqw1Twb0rEznYbVAiSZEuD9oS
            VUF2hkz8oJ68IGso0clqB0nuUdoS0hZyN25gEjttlSJr0FjBm0TQXEai4ymTT1H0
            EoyduJcH2RQs8ZJf4KVBpj27hHOaPuSFHhhIqSFNdCzVCaYoeDhObQyFBpO3NB2A
            T1B0XWQXifHWxsVE8DFXAHtnEFhpsgT4x5KFNxPC78QhaT386LkcKsQ3sawvpXsF
            dqqezXojmqziSIXZzpESknvMCY7Hs51JRTxhQ6XKwrXqqYQp0XcosEhf/F6e1+nS
            Eh7rbDEyoiry+dVYBWZ2Hzwml4eiBLKxzpvvjJTDPdJoAatnah8L1h29qjWVw+cH
            IUMx07nbTP5szUQUlhy3Te3pjK8JlESti1UPddYqyDgRiCxksD2H9ObcnQOk52Bp
            NYsjxhlokD7qK/uAWBkJvm6nsKNrueOeKygIn0jH/HUF4ZQU+JuOWvc=
            =AZ56
            -----END PGP MESSAGE-----
          pubkey: nLwhi0ikvoZ6kze+m+CP5wP0hsP4NgigHMMMiGrXung=
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
          privkey: |
            -----BEGIN PGP MESSAGE-----
            hQEMA0EEvUwCdTjhAQf/TftwB+67lMqAJ2kgj5LWSbkzbtryhNofAIUAztAh61Cp
            8kR1FGoIz74MhivNyUfglGf6ZAf8ly+1hWybS8GMfMFRTbBdR/uReitRAoXFbh9r
            XPojZ6bW0m+0TsmbyEuPvwQnf1dV9SoQYnwXAe1qF68Mwz5EAQ3dx0avST6pERNt
            t6HggHLqBsX7OvS2WEMqqodA9WVmNrBqPitzzkpPK53PFZDA9TWNGpgF08RgXneJ
            ktRpNPhPkBIct84BZqYInIeQBbSIFhi6hDqTeLIvmLlfgiw708WwT2jMK7ZQ4WS0
            QyWuEO0e19Xb9dpSD/2IUnRQMlVvWW2yasB067h2I9JoAW8rf5FTrj8WpMgS4GoS
            aKXk7++gV9R3q+D9XeGrSvR9yv4ktk+uJkCF8uj+7Lc7OX6IcHYc7CphQ9iI4R8x
            NIHUkUhJNsSA4a2e1AKUDQdwhr42HA8VLe7cB1L/uyEATARxALQq0MI=
            =6Fd7
            -----END PGP MESSAGE-----
          pubkey: 1eNW010lxDeySM09zOHOiZ+BoWx0vIywIlnJkD1hGRo=
        ip4:
          local: '192.168.67.11'
          remote: '192.168.67.10'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'

