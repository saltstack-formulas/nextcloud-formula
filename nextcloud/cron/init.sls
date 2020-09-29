# -*- coding: utf-8 -*-
# vim: ft=yaml

{% from "nextcloud/map.jinja" import nextcloud with context %}

# https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/background_jobs_configuration.html?highlight=cron
nextcloud-cron-cron-present:
  cron.present:
    - user: {{ nextcloud.webuser }}
    - minute: '*/5'
    - name: {{ nextcloud.php_executable }} -f {{ nextcloud.webroot }}/cron.php
    - identifier: nextcloud_cron
