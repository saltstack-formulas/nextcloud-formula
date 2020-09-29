# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import nextcloud with context %}

nextcloud-subcomponent-config-clean-file-absent:
  file.absent:
    - name: {{ nextcloud.subcomponent.config }}
{%- if nextcloud.apache.trigger_reload %}
    - watch_in:
      - module: apache-reload
{%- endif %}
