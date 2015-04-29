require_relative 'helpers'

module VagrantPlugins
  module CaCertificates
    module Cap
      module Redhat
        module CertificateUploadPath
          def self.certificate_upload_path(m)
            m.communicate.tap do |sh|
              return '/etc/pki/tls/private' if Redhat.legacy_certificate_bundle?(sh)
            end
            '/etc/pki/ca-trust/source/anchors'
          end
        end
      end
    end
  end
end
