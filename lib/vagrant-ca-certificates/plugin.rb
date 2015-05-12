I18n.load_path << File.expand_path('../../../locales/en.yml', __FILE__)

unless Gem::Requirement.new('>= 1.5').satisfied_by?(Gem::Version.new(Vagrant::VERSION))
  fail I18n.t('vagrant_ca_certificates.unsupported.vagrant_version', requirement: '>= 1.5')
end

module VagrantPlugins
  module CaCertificates
    class Plugin < Vagrant.plugin('2')
      name 'vagrant-ca-certificates'
      description <<-DESC
        Installs root certificates into guest operating system's trusted bundle.
      DESC

      config(:ca_certificates) do
        require_relative 'config'
        Config
      end

      action_hook(Plugin::ALL_ACTIONS) do |hook|
        require_relative 'action/install_certificates'
        hook.after(Vagrant::Action::Builtin::Provision, Action::InstallCertificates)
      end

      # All supported guest systems must have these capabilities
      # implemented. If any of them aren't config validate will fail.
      guest_capability('debian', 'update_certificate_bundle') do
        require_relative 'cap/debian/update_certificate_bundle'
        Cap::Debian::UpdateCertificateBundle
      end

      guest_capability('redhat', 'update_certificate_bundle') do
        require_relative 'cap/redhat/update_certificate_bundle'
        Cap::Redhat::UpdateCertificateBundle
      end

      guest_capability('debian', 'certificate_upload_path') do
        require_relative 'cap/debian/certificate_upload_path'
        Cap::Debian::CertificateUploadPath
      end

      guest_capability('redhat', 'certificate_upload_path') do
        require_relative 'cap/redhat/certificate_upload_path'
        Cap::Redhat::CertificateUploadPath
      end

      guest_capability('debian', 'certificate_file_bundle') do
        require_relative 'cap/debian/certificate_file_bundle'
        Cap::Debian::CertificateFileBundle
      end

      guest_capability('redhat', 'certificate_file_bundle') do
        require_relative 'cap/redhat/certificate_file_bundle'
        Cap::Redhat::CertificateFileBundle
      end
    end
  end
end
