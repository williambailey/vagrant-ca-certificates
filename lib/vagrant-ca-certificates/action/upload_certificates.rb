require 'vagrant/util/downloader'

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
            vm.sudo("chown 'root:root' '#{certs_path}'")
            vm.sudo("chmod '0777' '#{certs_path}'")
            i = 0
            config.certs.each do |cert|
              i += 1
              if cert =~ /^https?:\/\//
                tmp_file = Dir::Tmpname.create(["#{VagrantPlugins::CaCertificates::Plugin.name}_", '.crt']) { }
                env[:ui].info I18n.t("vagrant_ca_certificates.certificate.upload.download", from: cert)
                Vagrant::Util::Downloader.new(cert, tmp_file).download!
                self.upload(env[:ui], vm, i, tmp_file, certs_path)
                File::unlink(tmp_file)
              else
                self.upload(env[:ui], vm, i, cert, certs_path)
              end
            end unless config.certs.length == 0
            vm.sudo("chmod '0755' '#{certs_path}'")
            env[:ui].info I18n.t("vagrant_ca_certificates.certificate.upload.post")
          end

          @app.call(env)
        end

        def upload(ui, vm, cert_number, from, certs_path)
          to = File.join(certs_path, "#{cert_number}_#{File.basename(from)}")
          ui.info I18n.t("vagrant_ca_certificates.certificate.upload.cert", from: from, to: File.basename(to))
          vm.sudo("rm '#{to}'", error_check: false)
          vm.upload(from, to)
          vm.sudo("chown 'root:root' '#{to}'")
          vm.sudo("chmod '0644' '#{to}'")
        end

      end
    end
  end
end
