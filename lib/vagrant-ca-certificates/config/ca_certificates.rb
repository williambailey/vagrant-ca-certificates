require 'vagrant'

module VagrantPlugins
  module CaCertificates
    module Config
      class CaCertificates < Vagrant.plugin('2', :config)

        attr_accessor :enabled
        attr_accessor :certs

        def initialize
          @enabled = false
          @certs = []
        end

        def finalize!
        end

      end
    end
  end
end