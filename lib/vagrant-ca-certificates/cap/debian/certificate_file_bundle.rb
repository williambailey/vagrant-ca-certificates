module VagrantPlugins
  module CaCertificates
    module Cap
      module Debian
        module CertificateFileBundle
          def self.certificate_file_bundle(m)
            '/etc/pki/ssl/cert.pem'
          end
        end
      end
    end
  end
end
