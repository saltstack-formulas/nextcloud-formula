# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import nextcloud with context %}

nextcloud-client-install-pkg-installed:
  pkg.installed:
    - pkgs: {{ nextcloud.client.pkgs | json }}
