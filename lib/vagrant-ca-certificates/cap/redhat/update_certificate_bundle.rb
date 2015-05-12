require_relative 'helpers'

module VagrantPlugins
  module CaCertificates
    module Cap
      module Redhat
        # Capability for configuring the certificate bundle on Redhat.
        module UpdateCertificateBundle
          def self.update_certificate_bundle(m)
            m.communicate.tap do |sh|
              if Redhat.legacy_certificate_bundle?(sh)
                sh.sudo('find /etc/pki/tls/private -type f -exec cat {} \; | cat /etc/pki/tls/certs/ca-bundle.crt - > /etc/pki/tls/ca.private.crt')
                sh.sudo('/bin/ln -fsn /etc/pki/tls/ca.private.crt /etc/pki/tls/cert.pem')
                sh.sudo('/bin/ln -fsn /etc/pki/tls/ca.private.crt /etc/pki/tls/certs/ca-bundle.crt')
                sh.execute(<<-SCRIPT, shell: '/bin/bash', sudo: true)
if [ ! -z "$JAVA_HOME" ]; then \
find /etc/pki/tls/private -type f -exec $JAVA_HOME/bin/keytool -importcert \
 -trustcacerts -noprompt -storepass changeit \
 -keystore $JAVA_HOME/jre/lib/security/cacerts -file {} \\; \
else true; fi
                SCRIPT
              else
                sh.sudo('update-ca-trust enable')
                sh.sudo('update-ca-trust extract')
              end
            end
          end
        end
      end
    end
  end
end
