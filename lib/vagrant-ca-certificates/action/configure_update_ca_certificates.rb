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
            configure_machine env
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
        def configure_machine(env)
          conf_file = "/etc/ca-certificates.conf"
          conf_dir  = "/usr/share/ca-certificates/vagrant"

          @machine.communicate.tap do |comm|
            comm.sudo("rm -f #{conf_dir}/*", error_check: false)
            comm.sudo("mkdir #{conf_dir}", error_check: false)
            comm.sudo("chown 'root:root' #{conf_dir}")
            comm.sudo("chmod '0755' #{conf_dir}")
            comm.sudo("sed -i '/^vagrant/ d' '#{conf_file}'")
            i = 0
            config.certs.each do |cert|
              i += 1
              cert_name   = File.basename(cert)
              cert_file   = "#{i}_#{cert_name}"
              cert_upload = "/tmp/vagrant-ca-cert-#{cert_file}"
              cert_target = File.join(conf_dir, cert_file)
              env[:ui].info I18n.t("vagrant_ca_certificates.certificate.install", crt: cert_file)
              comm.sudo("rm #{cert_upload}", error_check: false)
              comm.upload(cert, cert_upload)
              comm.sudo("chmod '0644' #{cert_upload}")
              comm.sudo("chown 'root:root' #{cert_upload}")
              comm.sudo("mv '#{cert_upload}' #{cert_target}")
              comm.sudo("echo vagrant/#{cert_file} >> #{conf_file}")
            end
            comm.sudo("update-ca-certificates") do |type, data|
              if [:stderr, :stdout].include?(type)
                next if data =~ /stdin: is not a tty/
                env[:ui].info(data)
              end
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