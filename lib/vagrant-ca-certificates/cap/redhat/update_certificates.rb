module VagrantPlugins
  module CaCertificates
    module Cap
      module Redhat
        # Capability for configuring the certificate bundle on Redhat.
        module UpdateCertificates
          def self.update_certificates(machine)
            ca_certs = machine.config.ca_certificates.certs_path
            ca_bundle = '/etc/pki/tls/cacerts/ca_bundle.crt'

            # Assume that all of the certificates have been uploaded and just concatenate
            # them to the proper certificate bundle in /etc/pki/tls/cacerts.
            machine.communicate.sudo("find #{ca_certs} -type f -maxdepth 1 -exec cat {} >> #{ca_bundle} \\;")
          end
        end
      end
    end
  end
end
