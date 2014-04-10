module VagrantPlugins
  module CaCertificates
    module Cap
      module Redhat
        # Capability for configuring the certificate bundle on Debian.
        module UpdateCertificates
          def self.update_certificates(machine)
            ca_certs = machine.config.ca_certificates.certs_path
            ca_config = '/etc/ca-certificates.conf'

            machine.communicate.tap do |comm|
              comm.sudo("find #{ca_certs} -maxdepth 1 -exec echo {} #{ca_config} \\;")
              comm.sudo('update-ca-certificates')
            end
          end
        end
      end
    end
  end
end
