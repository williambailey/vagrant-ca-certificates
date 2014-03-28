require 'vagrant'

module VagrantPlugins
  module CaCertificates
    class Plugin < Vagrant.plugin('2')
      guest_capability 'debian', 'update_ca_certificates' do
        require_relative 'cap/debian/update_ca_certificates'
        Cap::Debian::UpdateCaCertificates
      end
    end
  end
end