require 'vagrant'

module VagrantPlugins
  module CaCertificates
    class Plugin < Vagrant.plugin('2')
      config 'ca_certificates' do
        require_relative 'config/ca_certificates'
        Config::CaCertificates
      end
    end
  end
end