# frozen_string_literal: true

control 'nextcloud client' do
  title 'should be installed'

  %w[
    nextcloud-desktop
    nextcloud-desktop-cmd
    nextcloud-desktop-l10n
  ].each do |package_name|
    describe package(package_name) do
      it { should be_installed }
    end
  end
end
