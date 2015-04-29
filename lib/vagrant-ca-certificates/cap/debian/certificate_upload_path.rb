module VagrantPlugins
  module CaCertificates
    module Cap
      module Debian
        module CertificateUploadPath
          def self.certificate_upload_path(m)
            '/usr/share/ca-certificates/private'
          end
        end
      end
    end
  end
end
