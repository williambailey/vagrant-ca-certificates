require 'vagrant/util/downloader'
require 'digest/md5'
require 'log4r'

module VagrantPlugins
  module CaCertificates
    module Action
      class InstallCertificates
        attr_accessor :logger

        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::ca-certificates')
        end

        def call(env)
          @app.call(env)
          return unless @machine.config.ca_certificates.enabled?

          create_certificates_directory
          @machine.ui.info(I18n.t('vagrant_ca_certificates.certificate.upload.message'))
          @machine.config.ca_certificates.certs.each do |file|
            to = File.join(certs_path, File.basename(file))
            upload_certificate(file, to)
          end
          @machine.guest.capability(:update_certificate_bundle)
          modify_etc_environment
        end

        def certs_path
          @machine.guest.capability(:certificate_upload_path)
        end

        def modify_etc_environment
          bundle_path = @machine.guest.capability(:certificate_file_bundle)
          @machine.communicate.tap do |sh|
            if sh.test("grep -q '^SSL_CERT_FILE=' /etc/environment", shell: '/bin/bash')
              sh.sudo(%{(sed "s/^SSL_CERT_FILE=.*/SSL_CERT_FILE=#{bundle_path}/" -i /etc/environment})
            else
              sh.sudo(%{echo "SSL_CERT_FILE=#{bundle_path}" >> /etc/environment})
            end
          end
        end

        def create_certificates_directory
          @machine.communicate.tap do |sh|
            return if sh.test("test -d #{certs_path}")
            sh.sudo("mkdir -p #{certs_path} && chmod 0744 #{certs_path}")
          end
        end

        def upload_certificate(from, to)
          remote = Tempfile.new('vagrant-ca-certificates')
          if from =~ /^http[s]?/
            Vagrant::Util::Downloader.new(from, remote.path).download!
            from = remote.path
          end

          @machine.communicate.tap do |sh|
            unless certificate_matches?(from, to)
              remote = Tempfile.new('va')
              @machine.ui.info(I18n.t('vagrant_ca_certificates.certificate.upload.file', from: from, to: to))
              sh.upload(from, remote.path)
              sh.sudo("mv #{remote.path} #{to} && chown root: #{to} && chmod 0644 #{to}")
            end
          end
        end

        def certificate_matches?(from, to)
          md5sum = Digest::MD5.file(from)
          @machine.communicate.tap do |sh|
            return false unless sh.test("test -f #{from}")
            return true if sh.test(%{test '#{md5sum}' = '$(md5sum "#{to}")'}, shell: '/bin/bash')
          end
          false
        end
      end
    end
  end
end
