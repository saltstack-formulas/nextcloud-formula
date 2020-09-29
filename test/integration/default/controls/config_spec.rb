# frozen_string_literal: true

control 'nextcloud configuration' do
  title 'should match desired lines'

  webroot =
    if system.platform[:family] == 'FreeBSD'
      '/usr/local/www/nextcloud'
    else
      '/var/www/nextcloud'
    end

  describe file("#{webroot}/config/salt-managed.config.php") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') do
      should include(
        'File managed by Salt'
      )
    end
    its('content') { should include '"appcodechecker" => true,' }
    its('content') { should include '"htaccess.RewriteBase" => "/",' }
    its('content') do
      should include(
        '"memcache.local" => "\\\\OC\\\\Memcache\\\\APCu",'
      )
    end
    its('content') { should include '"updatechecker" => true,' }
  end
end
