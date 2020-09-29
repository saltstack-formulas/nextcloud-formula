# frozen_string_literal: true

control 'nextcloud package' do
  title 'should be installed'

  package_name =
    case system.platform[:family]
    when 'FreeBSD'
      'nextcloud-php74'
    end

  webroot =
    if system.platform[:family] == 'FreeBSD'
      '/usr/local/www/nextcloud'
    else
      '/var/www/nextcloud'
    end

  webuser =
    if system.platform[:family] == 'FreeBSD'
      'www'
    else
      'www-data'
    end

  if package_name
    describe package(package_name) do
      it { should be_installed }
    end
  end

  describe file(webroot) do
    it { should be_directory }
    its('mode') { should cmp '0755' }
  end

  describe file("#{webroot}/config") do
    it { should be_directory }
    it { should be_owned_by webuser }
    its('mode') { should cmp '0755' }
  end
end
