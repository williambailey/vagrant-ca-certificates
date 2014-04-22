module VagrantPlugins
  module CaCertificates
    module Cap
      module Debian
        # Capability for configuring the certificate bundle on Debian.
        module UpdateCertificates
          def self.update_certificates(machine)
            ca_certs = File.join(machine.config.ca_certificates.certs_path, 'vagrant')
            ca_config = '/etc/ca-certificates.conf'

            machine.communicate.tap do |comm|
              comm.sudo("find #{ca_certs} -maxdepth 1 -type f -exec basename {} \\; | sed -e 's#^#vagrant\/#' >> #{ca_config} ")
              comm.sudo('update-ca-certificates')
            end
          end
        end
      end
    end
  end
end
