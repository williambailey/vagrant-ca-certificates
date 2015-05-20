module VagrantPlugins
  module CaCertificates
    module Cap
      module CoreOS
        module CertificateUploadPath
          def self.certificate_upload_path(m)
            '/etc/ssl/certs'
          end
        end
      end
    end
  end
end
