module VagrantPlugins
  module CaCertificates
    module Cap
      module Debian
        # Capability for configuring the certificate bundle on Debian.
        module UpdateCertificates
          def self.update_certificates(m)
            ca_certs = m.config.ca_certificates.certs_path
            ca_config = '/etc/ca-certificates.conf'
            ruby_ca_cert = '/usr/lib/ssl/cert.pem'
            m.communicate.tap do |comm|
              # Remove any existing references to vagrant certificates.
              comm.sudo("sed -i '/^vagrant/ d' '#{ca_config}'")
              # Add references to uploaded certificates.
              comm.sudo("find #{ca_certs} -maxdepth 1 -type f -exec basename {} \\; | sed -e 's#^#vagrant\/#' >> #{ca_config} ")
              # Update.
              comm.sudo("find #{ca_certs} -maxdepth 1 -type f -exec cat {} >> #{ruby_ca_cert} \\;")
              comm.sudo("update-ca-certificates") do |type, data|
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
end
