module VagrantPlugins
  module CaCertificates
    module Cap
      module Redhat
        module CertificateFileBundle
          def self.certificate_file_bundle(m)
            '/etc/pki/tls/cert.pem'
          end
        end
      end
    end
  end
end
