# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import nextcloud with context %}

{%- if grains["os"] == "Ubuntu" and nextcloud.get("use_ppa", True) %}
nextcloud--client--repo--ppa:
  pkgrepo.managed:
    - ppa: nextcloud-devs/client
    - require_in:
      - pkg: nextcloud-client-install-pkg-installed
{%- endif %}
