# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import nextcloud with context %}

nextcloud-service-clean-service-dead:
  service.dead:
    - name: {{ nextcloud.service.name }}
    - enable: False
