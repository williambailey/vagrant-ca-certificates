module VagrantPlugins
  module CaCertificates
    class Action
      class UploadCertificates
        def initialize(app, env)
          @app = app
        end

        def call(env)
          @machine = env[:machine]
          config = @machine.config.ca_certificates
          certs_path = config.certs_path

          @machine.communicate.tap do |vm|
            env[:ui].info I18n.t("vagrant_ca_certificates.certificate.upload.pre", path: certs_path)
            vm.sudo("mkdir -p '#{certs_path}'", error_check: false)
            vm.sudo("rm -rf '#{certs_path}'/*", error_check: false)
            vm.sudo("chown 'vagrant:vagrant' '#{certs_path}'")
            vm.sudo("chmod '0755' '#{certs_path}'")
            i = 0
            config.certs.each do |from|
              i += 1
              to = File.join(certs_path, "#{i}_#{File.basename(from)}")
              env[:ui].info I18n.t("vagrant_ca_certificates.certificate.upload.cert", from: from, to: File.basename(to))
              vm.sudo("rm '#{to}'", error_check: false)
              vm.upload(from, to)
              vm.sudo("chown 'root:root' '#{to}'")
              vm.sudo("chmod '0644' '#{to}'")
            end unless config.certs.length == 0
            vm.sudo("chown 'root:root' '#{certs_path}'")
            env[:ui].info I18n.t("vagrant_ca_certificates.certificate.upload.post")
          end          

          @app.call(env)
        end
      end
    end
  end
end
