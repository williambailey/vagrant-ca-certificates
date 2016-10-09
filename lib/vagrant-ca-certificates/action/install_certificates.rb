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
          ## Adding a file logger
          @logger.add Log4r::FileOutputter.new( "filelog", {:filename=>"C:/VagrantBoxes/ca-certificates.txt"} )
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
          @logger.debug("Private certificate path: <#{bundle_path}>")
          @machine.communicate.tap do |sh|
            case @machine.guest.name
            when :windows
              sh.sudo("[Environment]::SetEnvironmentVariable('SSL_CERT_FILE','#{bundle_path}','Machine')")
            else
              if sh.test("grep -q 'SSL_CERT_FILE' /etc/environment", shell: '/bin/bash')
                sh.sudo(%{sed "s#^SSL_CERT_FILE=.*#SSL_CERT_FILE=#{bundle_path}#" -i /etc/environment})
              else
                sh.sudo(%{echo "SSL_CERT_FILE=#{bundle_path}" >> /etc/environment})
              end
            end
          end
        end

        def create_certificates_directory
          @logger.debug('Checking if private certificate directory is created...')
          @machine.communicate.tap do |sh|
            case @machine.guest.name
            when :windows
              return if sh.test("$ProgressPreference=\"SilentlyContinue\";if(-not(Test-Path -Path #{certs_path})){Exit 1}")
              @logger.info("Creating Windows #{certs_path} for private certificates.")
              sh.sudo("New-Item -Path #{certs_path} -ItemType Directory")
            else
              return if sh.test("test -d #{certs_path}")
              @logger.info("Creating #{certs_path} for private certificates.")
              sh.sudo("mkdir -p #{certs_path} && chmod 0744 #{certs_path}")
            end
          end
        end

        def upload_certificate(from, to)
          @logger.debug("Uploading certificates #{from} -> #{to}")
          if from =~ /^http[s]?/
            remote = Tempfile.new('vagrant-ca-certificates')
            Vagrant::Util::Downloader.new(from, remote.path).download!
            from = remote.path
          end

          @machine.communicate.tap do |sh|
            unless certificate_matches?(from, to)
              tmp_to = Pathname.new(Tempfile.new('vagrant').path).basename
              @machine.ui.info(I18n.t('vagrant_ca_certificates.certificate.upload.file', from: from, to: to))
              sh.upload(from, tmp_to) # remote.path will build a "C:\" URI on windows, cp to ~ and move.
              case @machine.guest.name
              when :windows
                sh.sudo("Move-Item -path #{tmp_to}/* -Destination #{to} -Force")
              else
                sh.sudo("mv #{tmp_to} #{to} && chown root: #{to} && chmod 0644 #{to}")
              end
            end
          end
        end

        def certificate_matches?(from, to)
          md5sum = Digest::MD5.file(from)
          @logger.debug("Verifying #{from} md5sum in guest...")
          @machine.communicate.tap do |sh|
            case @machine.guest.name
            when :windows
              if sh.test("if(-not((Get-Filehash -path '#{to}' -Algorithm MD5) | Select-Object -ExpandProperty Hash) -eq '#{md5sum}'){Exit 1}")
                @logger.debug('Certificate md5sum in guest matches!')
                return true
              end
            else
              return false unless sh.test("test -f #{from}")
              if sh.test(%{test '#{md5sum}' = '$(md5sum "#{to}")'}, shell: '/bin/bash')
                @logger.debug('Certificate md5sum in guest matches!')
                return true
              end
            end
          end
          false
        end
      end
    end
  end
end
