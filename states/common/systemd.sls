systemd.system:
  file.directory:
    - name: /usr/local/systemd/system/
    - makedirs: True
    - clean: True
