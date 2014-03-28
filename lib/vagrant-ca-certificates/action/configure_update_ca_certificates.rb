require 'vagrant'
require_relative '../logger'

module VagrantPlugins
  module CaCertificates
    class Action
      class ConfigureUpdateCaCertificates
        def initialize(app, env)
          @app = app
        end

        def call(env)
          @machine = env[:machine]

          if !config.enabled?
            logger.info I18n.t("vagrant_ca_certificates.update_ca_certificates.not_enabled")
          elsif !supported?
            logger.info I18n.t("vagrant_ca_certificates.update_ca_certificates.not_supported")
          else
            env[:ui].info I18n.t("vagrant_ca_certificates.update_ca_certificates.configuring")
            configure_machine
          end

          @app.call env
        end

        private

        # @return [Log4r::Logger]
        def logger
          CaCertificates.logger
        end

        # @return [Vagrant::Plugin::V2::Config] the configuration
        def config
          return @config if @config
          @config = @machine.config.public_send(:ca_certificates)
        end

        # Configures the VM based on the config
        def configure_machine
          conf_file = config_conf
          conf_dir  = config_dir
          logger.debug "Configuration (#{conf_file}): #{conf_dir}"
          # something like...
          # loop over all config certs
          # comm.upload("xxxx.crt", "#{conf_file}/xxxx.crt")
          # comm.sudo("chmod '0644' #{conf_file}/xxxx.crt")
          # comm.sudo("chown 'root:root' #{conf_file}/xxxx.crt")          
          # comm.sudo("echo 'xxxx.crt' >> #{conf_file}")
          # then
          # comm.sudo("update-ca-certificates")
        end

        def cap_name
          "ca_certificates_dir".to_sym
          "ca_certificates_conf".to_sym
        end

        def supported?
          @machine.guest.capability?("ca_certificates_dir".to_sym) &&
            @machine.guest.capability("ca_certificates_dir".to_sym) &&
              @machine.guest.capability?("ca_certificates_conf".to_sym) &&
                @machine.guest.capability("ca_certificates_conf".to_sym)
        end

        def config_dir
          @machine.guest.capability("ca_certificates_dir".to_sym)
        end

        def config_conf
          @machine.guest.capability("ca_certificates_conf".to_sym)
        end


      end
    end
  end
end