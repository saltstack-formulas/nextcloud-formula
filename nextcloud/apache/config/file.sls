# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import nextcloud with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_config_file }}

nextcloud-apache-config-file-file-managed:
  file.managed:
    - name: {{ nextcloud.apache.config_snippet }}
    - source: {{ files_switch(['nextcloud-snippet.conf.tmpl.jinja'],
                              lookup='nextcloud-apache-config-file-file-managed',
                              use_subpath=True
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ nextcloud.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        nextcloud: {{ nextcloud | json }}
    - require_in:
      - sls: {{ sls_config_file }}
{%- if nextcloud.apache.trigger_reload %}
    - watch_in:
      - module: apache-reload
{%- endif %}
