# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import nextcloud with context %}

include:
  - {{ sls_config_clean }}

{%- if nextcloud.install_mode == 'pkg' %}

nextcloud-package-clean-pkg-removed:
  pkg.removed:
    - name: {{ nextcloud.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}

{%- else %}

nextcloud-package-clean-directory-removed:
  file.absent:
    - name: {{ nextcloud.webroot }}
    - recurse: True

{%- endif %}
