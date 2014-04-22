require 'vagrant/action/builtin/call'
require_relative 'action/is_enabled'
require_relative 'action/only_once'
require_relative 'action/update_certificates'
require_relative 'action/upload_certificates'

module VagrantPlugins
  module CaCertificates
    # Middleware stack builders
    class Action
      # Shortcut
      Builtin = Vagrant::Action::Builtin

      # Returns an action middleware stack that configures the VM
      #
      # @param opts [Hash] the options to be passed to {OnlyOnce}
      # @option (see OnlyOnce#initialize)
      def self.configure(opts = {})
        Vagrant::Action::Builder.build(OnlyOnce, opts, &config_actions)
      end

      private

      # @return [Proc] the block that adds config actions to the specified
      #   middleware builder
      def self.config_actions
        @config_actions ||= Proc.new do |b|
          b.use Builtin::Call, IsEnabled do |env, b2|
            next unless env[:result]
            b2.use UploadCertificates
            b2.use UpdateCertificates
          end
        end
      end

    end
  end
end
