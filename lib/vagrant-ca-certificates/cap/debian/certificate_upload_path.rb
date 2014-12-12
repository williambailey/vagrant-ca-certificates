module VagrantPlugins
  module CaCertificates
    module Cap
      module Debian
        module CertificateUploadPath
          def self.certificate_upload_path(m)
            '/usr/local/share/ca-certificates/vagrant'
          end
        end
      end
    end
  end
end
