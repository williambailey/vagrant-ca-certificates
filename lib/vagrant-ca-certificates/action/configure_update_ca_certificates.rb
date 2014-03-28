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
          config.certs.each do |cert|
            # TODO: check to see if cert is already installed.
            cert_name   = File.basename(cert)
            cert_target = File.join(conf_dir, cert_name)
            comm.upload(cert, cert_target)
            comm.sudo("chmod '0644' #{cert_target}")
            comm.sudo("chown 'root:root' #{cert_target}")
            comm.sudo("echo #{cert_name} >> #{conf_file}")
          end
          comm.sudo("update-ca-certificates")
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