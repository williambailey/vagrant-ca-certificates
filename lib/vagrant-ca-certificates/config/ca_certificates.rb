require 'vagrant'
require 'vagrant/util/downloader'
require 'tempfile'

module VagrantPlugins
  module CaCertificates
    module Config
      class CaCertificates < Vagrant.plugin('2', :config)
        attr_accessor :enabled
        attr_accessor :certs
        attr_accessor :certs_path

        def initialize
          @enabled = UNSET_VALUE
          @certs = UNSET_VALUE
          @certs_path = UNSET_VALUE
        end

        def finalize!
          @enabled = false if @enabled == UNSET_VALUE
          @certs = [] if @certs == UNSET_VALUE
          @certs_path = '/usr/share/ca-certificates/vagrant' if @certs_path == UNSET_VALUE

          # This blows up with "...CaCertificates::URL (NameError)"
          #@certs.each do |cert|
          #  next unless cert.is_a?(URL)
          #  tempfile = Tempfile.new(['cacert', '.pem'])
          #  Vagrant::Util::Downloader.new(cert.to_s, tempfile.path)
          #  cert = tempfile.path
          #end
        end
      end
    end
  end
end
