module VagrantPlugins
  module CaCertificates
    module Cap
      module Redhat
        # HACK: All versions of EL5 and below EL6.5 do not have
        # support for the `update-ca-trust` command and thus the
        # bundles must be managed manually.
        def self.legacy_certificate_bundle?(sh)
          command = %q(R=$(sed -E "s/.* ([0-9])\.([0-9]+) .*/\\1.\\2/" /etc/redhat-release))
          sh.test(%Q(#{command} && [[ $R =~ ^5 || $R =~ ^6\.[0-4]+ ]]), shell: '/bin/bash') || !sh.test("rpm -q --verify --nomtime ca-certificates", shell:'/bin/bash')
        end
      end
    end
  end
end
