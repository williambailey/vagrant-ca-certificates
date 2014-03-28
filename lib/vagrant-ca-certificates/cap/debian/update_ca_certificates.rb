module VagrantPlugins
  module CaCertificates
    module Cap
      module Debian
        # Capability for update-ca-certificates configuration
        module UpdateCaCertificates
          # @return [String] the path to the certificates directory
          def self.ca_certificates_dir(machine)
            '/usr/share/ca-certificates/'
          end
          # @return [String] the path to the configuration file
          def self.ca_certificates_conf(machine)
            '/etc/ca-certificates.conf'
          end
        end
      end
    end
  end
end