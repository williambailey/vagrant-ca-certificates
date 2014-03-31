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

          if !config.enabled? || config.enabled != true
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
          conf_file = "/etc/ca-certificates.conf"
          conf_dir  = "/usr/share/ca-certificates/"
          config.certs.each do |cert|
            cert_name   = File.basename(cert)
            cert_upload = "/tmp/vagrant-ca-cert-#{cert_name}"
            cert_target = File.join(conf_dir, cert_name)
            @machine.communicate.tap do |comm|
              comm.sudo("rm #{cert_upload}", error_check: false)
              comm.upload(cert, cert_upload)
              comm.sudo("chmod '0644' #{cert_upload}")
              comm.sudo("chown 'root:root' #{cert_upload}")
              comm.sudo("mv '#{cert_upload}' #{cert_target}")
              comm.sudo("echo #{cert_name} >> #{conf_file}")
              comm.sudo("update-ca-certificates")
            end
          end
        end

        def supported?
          # TODO: Figure out why the capability isn't working.
          return true
          @machine.guest.capability?("update_ca_certificates".to_sym) &&
            @machine.guest.capability("update_ca_certificates".to_sym)
        end

      end
    end
  end
end