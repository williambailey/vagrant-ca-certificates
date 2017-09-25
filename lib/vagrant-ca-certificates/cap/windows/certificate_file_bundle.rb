module VagrantPlugins
  module CaCertificates
    module Cap
      module Windows
        module CertificateFileBundle
          def self.certificate_file_bundle(m)
            'C:/ssl/cacert.pem'
          end
        end
      end
    end
  end
end
