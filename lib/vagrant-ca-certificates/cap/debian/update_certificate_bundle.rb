module VagrantPlugins
  module CaCertificates
    module Cap
      module Debian
        # Capability for configuring the certificate bundle on Debian.
        module UpdateCertificateBundle
          def self.update_certificate_bundle(m)
            m.communicate.sudo('update-ca-certificates') do |type, data|
              if [:stderr, :stdout].include?(type)
                next if data =~ /stdin: is not a tty/
                m.env.ui.info data
              end
            end
          end
        end
      end
    end
  end
end
