{% from 'smartmontools/map.jinja' import smartmontools_settings with context %}

smartmontools:
  pkg.installed:
    - name: {{ smartmontools_settings.pkg }}
  service.running:
    - enable: True
    - restart: True
    - name: {{ smartmontools_settings.service }}
    - require:
      - pkg: smartmontools

/etc/default/smartmontools:
  file.uncomment:
    - regex: "start_smartd=yes"
    - require:
      - pkg: smartmontools
    - watch_in:
      - service: smartmontools

/etc/smartd.conf:
  file.managed:
    - source: salt://smartmontools/files/smartd.conf.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - watch_in:
      - service: smartmontools

