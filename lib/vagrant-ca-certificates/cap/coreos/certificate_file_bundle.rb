module VagrantPlugins
  module CaCertificates
    module Cap
      module CoreOS
        module CertificateFileBundle
          def self.certificate_file_bundle(m)
            '/etc/ssl/certs/ca-certificates.crt'
          end
        end
      end
    end
  end
end
