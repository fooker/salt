odroid.fan:
  file.managed:
    - name: /etc/udev/rules.d/99-odroid_fan.rules
    - source: salt://odroid/files/fan.rules
    - makedirs: True

odroid.led:
  file.managed:
    - name: /etc/udev/rules.d/99-odroid_led.rules
    - source: salt://odroid/files/led.rules
    - makedirs: True
