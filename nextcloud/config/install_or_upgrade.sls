# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import nextcloud with context %}

{%- set admin_cred = nextcloud.initial_admin_credentials %}
{%- set admin_pw = admin_cred.get('pass', salt['random.get_str'](40)) %}
{%- set datadir = nextcloud.get('datadir', nextcloud.webroot+'/data') %}

include:
  - {{ sls_package_install }}

# Install?
nextcloud-config-install_or_update-install-cmd-run:
  cmd.run:
    - name: {{ nextcloud.php_executable }} occ maintenance:install --no-interaction {% for key, value in nextcloud.database.items() -%}
      {%- set arg = 'database' if key == 'driver' else 'database-{}'.format(key) -%}
      --{{ arg }}={{ value }}{{ ' ' }}
    {%- endfor %} --admin-user={{ admin_cred.user }} --admin-pass={{ admin_pw }} --admin-email={{ admin_cred.email }} --data-dir={{ datadir }}
    - runas: {{ nextcloud.webuser }}
    - cwd: {{ nextcloud.webroot }}
    # Checks whether the install already happended. (Then maintenance:install disappears.)
    - onlyif: sh -c '{{ nextcloud.php_executable }} {{ nextcloud.webroot }}/occ | grep maintenance:install'
    - require:
      - sls: nextcloud.package.install

# Upgrade
nextcloud-config-install_or_update-upgrade-cmd-run:
  cmd.run:
    - name: {{ nextcloud.php_executable }} occ upgrade --no-interaction
    - runas: {{ nextcloud.webuser }}
    - cwd: {{ nextcloud.webroot }}
    - onchanges:
      - sls: nextcloud.package.install
    - require:
      - cmd: nextcloud-config-install_or_update-install-cmd-run
