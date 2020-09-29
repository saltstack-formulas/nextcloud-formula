# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import nextcloud with context %}

include:
  - {{ sls_package_install }}

# https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/config_sample_php_parameters.html?highlight=htaccess#proxy-configurations

{%- set htaccess_file = "{}/.htaccess".format(nextcloud.webroot) %}
{%- set fix_perms = "chown {} {}".format(nextcloud.webuser, htaccess_file) %}
nextcloud-config-htaccess-cmd-run-htaccess:
  cmd.run:
    - name: "{{ fix_perms }} && su -m {{ nextcloud.webuser }} -c '{{ nextcloud.php_executable }} occ maintenance:update:htaccess'"
    - cwd: {{ nextcloud.webroot }}
    - onchanges:
      - file: nextcloud-config-file-file-managed
    - onlyif: test -f "{{ htaccess_file }}"

# Ensure correct permissions
nextcloud-config-htaccess-file-managed-htaccess:
  file.managed:
    - name: {{ htaccess_file }}
    - replace: False
    - user: root
    - require:
      - cmd: nextcloud-config-htaccess-cmd-run-htaccess
