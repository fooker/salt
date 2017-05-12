## Generate IPSec key-pair with the following commands:
##  ipsec pki --gen --type rsa --outform pem --size 4096 > /etc/ipsec.d/private/self.pem
##  ipsec pki --pub --in /etc/ipsec.d/private/self.pem --outform pem > /etc/ipsec.d/certs/self.pem

peering:
  domains:
    hive:
      ospf_id: 23

  interfaces:
    north-zitadelle:
      dn42:
        ip4:
          address: 172.23.200.1
          netmask: 32
        ip6:
          address: fd79:300d:6056::1
          netmask: 128
      hive:
        ip4:
          address: 192.168.33.1
          netmask: 32
        ip6:
          address: fd4c:8f0:aff2::1
          netmask: 128
    south-zitadelle:
      dn42:
        ip4:
          address: 172.23.200.2
          netmask: 32
        ip6:
          address: fd79:300d:6056::2
          netmask: 128
      hive:
        ip4:
          address: 192.168.33.2
          netmask: 32
        ip6:
          address: fd4c:8f0:aff2::2
          netmask: 128
    bunker:
      hive:
        ip4:
          address: 192.168.33.3
          netmask: 32
        ip6:
          address: fd4c:8f0:aff2::3
          netmask: 128

  peers:
    major:
      type: gre
      proto: bgp
      domains:
        - dn42
      netdev: major
      remote: '1.2.3.0'
      pubkey: |
        -----BEGIN PUBLIC KEY-----
        -----END PUBLIC KEY-----

    andi:
      type: gre
      proto: bgp
      domains:
        - dn42
      netdev: andi
      remote: '1.2.3.1'
      pubkey: |
        -----BEGIN PUBLIC KEY-----
        -----END PUBLIC KEY-----

    hexa:
      type: gre
      proto: bgp
      domains:
        - dn42
      netdev: hexa
      remote: '1.2.3.2'
      pubkey: |
        -----BEGIN PUBLIC KEY-----
        -----END PUBLIC KEY-----

    jojo:
      type: gre
      proto: bgp
      domains:
        - dn42
      netdev: jojo
      remote: '1.2.3.3'
      pubkey: |
        -----BEGIN PUBLIC KEY-----
        -----END PUBLIC KEY-----

    maglab:
      type: gre
      proto: bgp
      domains:
        - dn42
      netdev: maglab
      remote: '1.2.3.4'
      pubkey: |
        -----BEGIN PUBLIC KEY-----
        -----END PUBLIC KEY-----

    north-zitadelle:
      type: gre
      proto: ospf
      domains:
        - dn42
        - hive
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

    south-zitadelle:
      type: gre
      proto: ospf
      domains:
        - dn42
        - hive
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

    bunker:
      type: gre
      proto: ospf
      domains:
        - dn42
        - hive
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


  transfers:
    north-zitadelle:
      major:
        ip4:
          local: '1.2.3.4'
          remote: ''
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      andi:
        ip4:
          local: '1.2.3.4'
          remote: '1.2.3.5'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      hexa:
        ip4:
          local: '1.2.3.4'
          remote: '1.2.3.5'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      jojo:
        ip4:
          local: '1.2.3.4'
          remote: '1.2.3.5'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      maglab:
        ip4:
          local: '1.2.3.4'
          remote: '1.2.3.5'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
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
      andi:
        ip4:
          local: '1.2.3.4'
          remote: '1.2.3.5'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      hexa:
        ip4:
          local: '1.2.3.4'
          remote: '1.2.3.5'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      jojo:
        ip4:
          local: '1.2.3.4'
          remote: '1.2.3.5'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      maglab:
        ip4:
          local: '1.2.3.4'
          remote: '1.2.3.5'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
      north-zitadelle:
        ip4:
          local: '192.168.67.1'
          remote: '192.168.67.0'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'
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
          local: 'fe80::1'
          remote: 'fe80::2'
      south-zitadelle:
        ip4:
          local: '192.168.67.3'
          remote: '192.168.67.2'
        ip6:
          local: 'fe80::1'
          remote: 'fe80::2'

