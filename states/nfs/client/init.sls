include:
  - nfs


nfs.client.mount:
  mount.mounted:
    - name: /mnt/data
    - device: 'bunker:/'
    - fstype: nfs4
    - mkmnt: True
    - opts: noatime
    - persist: True

