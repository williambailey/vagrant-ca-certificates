module VagrantPlugins
  module CaCertificates
    module Cap
      module Windows
        module CertificateUploadPath
          def self.certificate_upload_path(m)
            'C:/ssl/certs'
          end
        end
      end
    end
  end
end
