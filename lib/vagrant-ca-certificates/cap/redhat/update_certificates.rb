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
            #
            # TODO: make idempotent.
            #
            # Currently this will not remove any previously installed vagrant certificate and
            # will append a copy of the uploaded certificates each time provision is run. If
            # you run provision multiple time then you will see the certificates duplicated
            # in the ca-cundle.crt file.
            machine.communicate.sudo("find #{ca_certs} -maxdepth 1 -type f -exec cat {} >> #{ca_bundle} \\;")
          end
        end
      end
    end
  end
end
