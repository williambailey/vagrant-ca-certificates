module VagrantPlugins
  module CaCertificates
    module Cap
      module Redhat
        # Capability for configuring the certificate bundle on Redhat.
        module UpdateCertificates
          def self.update_certificates(machine)
            ca_certs = File.join(machine.config.ca_certificates.certs_path, 'vagrant')
            ca_bundle = '/etc/pki/tls/certs/ca-bundle.crt'

            # Assume that all of the certificates have been uploaded and just concatenate
            # them to the proper certificate bundle in /etc/pki/tls/cacerts.
            machine.communicate.sudo("find #{ca_certs} -maxdepth 1 -type f -exec cat {} >> #{ca_bundle} \\;")
          end
        end
      end
    end
  end
end
