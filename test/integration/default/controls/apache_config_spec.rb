# frozen_string_literal: true

control 'nextcloud apache configuration' do
  title 'should match desired lines'

  describe file('/etc/apache2/nextcloud-snippet.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include('# File managed by Salt at') }
    its('content') { should include('Directory /var/www/nextcloud') }
  end
end
