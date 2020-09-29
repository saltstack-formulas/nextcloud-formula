# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import nextcloud with context %}

{%- if nextcloud.install_mode == 'pkg' %}

nextcloud-package-install-pkg-installed:
  pkg.installed:
    - name: {{ nextcloud.pkg.name }}

{%- else %}
# https://docs.nextcloud.com/server/19/admin_manual/installation/source_installation.html
# https://docs.nextcloud.com/server/19/admin_manual/installation/example_ubuntu.html

nextcloud-package-install-webroot-file-managed:
  file.directory:
    - name: {{ nextcloud.webroot }}
    - user: {{ nextcloud.webuser }}
    - group: {{ nextcloud.webuser }}
    - makedirs: True

{%-   set archive = "{}.tar.bz2".format(nextcloud.archive.name) %}
{%-   set archive_path = "{}/.archive/{}".format(nextcloud.webroot, archive) %}

nextcloud-package-install-archive-file-managed:
  file.managed:
    - name: {{ archive_path }}
    - source: https://download.nextcloud.com/server/releases/{{ archive }}
    - source_hash: https://download.nextcloud.com/server/releases/{{ archive }}.sha512
    - makedirs: True
    - require:
      - file: nextcloud-package-install-webroot-file-managed

nextcloud-package-install-archive-unpack:
  cmd.run:
    - name: tar --extract --file {{ archive_path }} --strip-components=1
    - runas: {{ nextcloud.webuser }}
    - cwd: {{ nextcloud.webroot }}
    - onchanges:
      - file: nextcloud-package-install-archive-file-managed

{%- endif %}
