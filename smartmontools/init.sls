{% from 'smartmontools/map.jinja' import map with context %}

{% set client_id = salt['grains.get']('id') %}

install_smartmontools_on_{{ client_id }}:
  pkg.installed:
    - name: {{ map.pkg }}
  service.running:
    - enable: True
    - restart: True
    - name: {{ map.service }}
    - require:
      - pkg: install_smartmontools_on_{{ client_id }}

enable_smartd_autostart_on_{{ client_id }}:
  file.uncomment:
    - name: {{ map.defaults_start }}
    - regex: "start_smartd=yes"
    - require:
      - pkg: install_smartmontools_on_{{ client_id }}
    - watch_in:
      - service: install_smartmontools_on_{{ client_id }}

create_smartd_config_on_{{ client_id }}:
  file.managed:
    - name: {{ map.config }}
    - source: salt://smartmontools/files/smartd.conf.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - watch_in:
      - service: install_smartmontools_on_{{ client_id }}
    - context:
      health: {{ map.health }}
      email: {{ map.email }}
      test_email: {{ map.test_email }}

      test_1_type: {{ map.test_1.type }}
      test_1_mon: {{ map.test_1.mon }}
      test_1_day: {{ map.test_1.day }}
      test_1_w_day: {{ map.test_1.w_day }}
      test_1_hour: {{ map.test_1.hour }}

      test_2_type: {{ map.test_2.type }}
      test_2_mon: {{ map.test_2.mon }}
      test_2_day: {{ map.test_2.day }}
      test_2_w_day: {{ map.test_2.w_day }}
      test_2_hour: {{ map.test_2.hour }}

      test_3_type: {{ map.test_3.type }}
      test_3_mon: {{ map.test_3.mon }}
      test_3_day: {{ map.test_3.day }}
      test_3_w_day: {{ map.test_3.w_day }}
      test_3_hour: {{ map.test_3.hour }}


