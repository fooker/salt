## Generate IPSec key-pair with the following commands:
##  ipsec pki --gen --type rsa --outform pem --size 4096 > /etc/ipsec.d/private/self.pem
##  ipsec pki --pub --in /etc/ipsec.d/private/self.pem --outform pem > /etc/ipsec.d/certs/self.pem

peering:
  domains:
    hive:
      ospf:
        instance_id: 23
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
      ospf:
        instance_id: 42
      bgp:
        as: 4242421271
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
          #          - 10.4.0.0/16+         # ..
          #          - 10.9.0.0/16+         # ..
          #          - 10.32.0.0/16+        # ..
          #          - 10.42.0.0/16+        # ..
          #          - 10.96.0.0/16+        # ..
          #          - 10.100.0.0/14+       # ..
          #          - 10.104.0.0/14        # ..
          - 10.0.0.0/8+          # Freifunk
        ip6:
          - fc00::/7{44,64}      # ULAs

  interfaces:
    north-zitadelle:
      hive:
        ip4:
          address: 192.168.33.1
          netmask: 32
        ip6:
          address: fd4c:8f0:aff2::1
          netmask: 128
      dn42:
        ip4:
          address: 172.23.200.1
          netmask: 32
        ip6:
          address: fd79:300d:6056::1
          netmask: 128
    south-zitadelle:
      hive:
        ip4:
          address: 192.168.33.2
          netmask: 32
        ip6:
          address: fd4c:8f0:aff2::2
          netmask: 128
      dn42:
        ip4:
          address: 172.23.200.2
          netmask: 32
        ip6:
          address: fd79:300d:6056::2
          netmask: 128
    bunker:
      hive:
        ip4:
          address: 192.168.33.3
          netmask: 32
        ip6:
          address: fd4c:8f0:aff2::3
          netmask: 128
      dn42:
        ip4:
          address: 172.23.200.2
          netmask: 32
        ip6:
          address: fd79:300d:6056::2
          netmask: 128

  peers:
    major:
      type: gre6
      proto: bgp
      as: 4242422600
      domains:
        - dn42
      netdev: major
      remote: '2a02:c205:3000:5324::42'
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

#    andi:
#      type: gre
#      proto: bgp
#      as: 424240000
#      domains:
#        - dn42
#      netdev: andi
#      remote: '1.2.3.1'
#      pubkey: |
#        -----BEGIN PUBLIC KEY-----
#        -----END PUBLIC KEY-----
#      ike: aes128-sha256-modp2048!
#      esp: aes128-sha1-modp2048!

#    hexa:
#      type: gre
#      proto: bgp
#      as: 424240000
#      domains:
#        - dn42
#      netdev: hexa
#      remote: '1.2.3.2'
#      pubkey: |
#        -----BEGIN PUBLIC KEY-----
#        -----END PUBLIC KEY-----
#      ike: aes128-sha256-modp2048!
#      esp: aes128-sha1-modp2048!

    jojo:
      type: gre6
      proto: bgp
      as: 4242423942
      domains:
        - dn42
      netdev: jojo
      remote: '2a03:4000:f:8::1'
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

#    maglab:
#      type: gre
#      proto: bgp
#      as: 424240000
#      domains:
#        - dn42
#      netdev: maglab
#      remote: '1.2.3.4'
#      pubkey: |
#        -----BEGIN PUBLIC KEY-----
#        -----END PUBLIC KEY-----
#      ike: aes128-sha256-modp2048!
#      esp: aes128-sha1-modp2048!

    north-zitadelle:
      type: gre
      proto: ospf
      domains:
        - hive
        - dn42
      netdev: alpha
      remote: '37.120.172.185'
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

    south-zitadelle:
      type: gre
      proto: ospf
      domains:
        - hive
        - dn42
      netdev: beta
      remote: '37.120.172.177'
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

    bunker:
      type: gre
      proto: ospf
      domains:
        - hive
        - dn42
      netdev: gamma
      remote: '37.120.161.15'
      pubkey: |
        -----BEGIN PUBLIC KEY-----
        MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAvEdSeO26zc7UBbUR5mh2
        L2zh1yfIjs+0KBFT1nK1tTnhDIQLbXsPoh2kJ7VQvIzEnDOh35Zih+ok80t5VNAa
        I0nzmLbTF5pw3fREgdII6P3TT497IDhS9pYlnRBgacj4vKmTL9fQZ0A9E38bSd1W
        oLcB7P/KhTDcm0moo2AIyCi1Azcafj2wnpCeQioDSSHbbR02vwOJhcUi9fBZKObV
        z+DnfOcnsGjZBIGRIxwiNFy9Lqz+DalaE/IC3Af4J+q67VghD/J+03UFtxn1ORuR
        DO/9nd/Wx/FN/NaeWeGqqMzf93ZKbbETfXPolZUN3IgUiVKyeBiuqpzook7HndC+
        RbKCaw2m4F12si2jUJICVDUFk4EYJL4O7UYKr9X9Vo/IFng61yCpZwVtSI954Qg1
        h/ahQF6BM1ysxvd7/eN/Zg6Aj/JwSb6g7m8rL82NsVX+09KB/p6xZ/Hta2uZjS5Z
        iybzCRAvnsBU0diUf0NcT7UxASpN7SNv7uC58gVjnEqy2LHvQ5Pa53POp06PwTDC
        9LFQmE2YB9JPenjfGCDm8XdXZ7M7dpbcrUEiwhmyZVwYO1S5c3J7YpxwSZyry70x
        2BJdJf6oyFXlQbSZgd4eX+8AJcPGub0B2ZC9WOdk8EyioikhoWJHSQP8diPBzLUn
        GlXY4FK3RV5o+0ycVmOiYRMCAwEAAQ==
        -----END PUBLIC KEY-----
      ike: aes256-sha512-curve25519!
      esp: aes256-sha512-curve25519!


  transfers:
    north-zitadelle:
      major:
        ip4:
          local: '172.20.240.150'
          remote: '172.20.240.149'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
#      andi:
#        ip4:
#          local: '1.2.3.4'
#          remote: '1.2.3.5'
#        ip6:
#          local: 'fe80::1'
#          remote: 'fe80::2'
#      hexa:
#        ip4:
#          local: '1.2.3.4'
#          remote: '1.2.3.5'
#        ip6:
#          local: 'fe80::1'
#          remote: 'fe80::2'
      jojo:
        ip4:
          local: '172.20.193.21'
          remote: '172.20.193.20'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
#      maglab:
#        ip4:
#          local: '1.2.3.4'
#          remote: '1.2.3.5'
#        ip6:
#          local: 'fe80::1'
#          remote: 'fe80::2'
      south-zitadelle:
        ip4:
          local: '192.168.67.0'
          remote: '192.168.67.1'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      bunker:
        ip4:
          local: '192.168.67.4'
          remote: '192.168.67.5'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
    south-zitadelle:
      major:
        ip4:
          local: '1.2.3.4'
          remote: '1.2.3.5'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
#      andi:
#        ip4:
#          local: '1.2.3.4'
#          remote: '1.2.3.5'
#        ip6:
#          local: 'fe80::1'
#          remote: 'fe80::2'
#      hexa:
#        ip4:
#          local: '1.2.3.4'
#          remote: '1.2.3.5'
#        ip6:
#          local: 'fe80::1'
#          remote: 'fe80::2'
      jojo:
        ip4:
          local: '172.20.193.23'
          remote: '172.20.193.22'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
#      maglab:
#        ip4:
#          local: '1.2.3.4'
#          remote: '1.2.3.5'
#        ip6:
#          local: 'fe80::1'
#          remote: 'fe80::2'
      north-zitadelle:
        ip4:
          local: '192.168.67.1'
          remote: '192.168.67.0'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      bunker:
        ip4:
          local: '192.168.67.2'
          remote: '192.168.67.3'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
    bunker:
      north-zitadelle:
        ip4:
          local: '192.168.67.5'
          remote: '192.168.67.4'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'
      south-zitadelle:
        ip4:
          local: '192.168.67.3'
          remote: '192.168.67.2'
        ip6:
          local: 'fe80::2'
          remote: 'fe80::1'

