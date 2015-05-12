require 'vagrant'

module VagrantPlugins
  module CaCertificates
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :certs, :enabled

      def initialize
        @certs = UNSET_VALUE
        @enabled = UNSET_VALUE
      end

      def enabled?
        @enabled == true
      end

      def disabled?
        !enabled?
      end

      def disable!
        @enabled = false
      end

      def validate(machine)
        errors = []
        if enabled?
          # If the certificates specified do not exist on the host
          # disk we should error out very loudly. Because this will
          # likely affect guest operation.
          @certs.reject { |f| File.exist?(f) }.each do |f|
            errors << I18n.t('vagrant_ca_certificates.certificate.not_found', filepath: f)
          end
        end

        { 'vagrant-ca-certificates' => errors }
      end

      def finalize!
        @enabled = false if @enabled == UNSET_VALUE
        @certs = [] if @certs == UNSET_VALUE
      end
    end
  end
end
