module VagrantPlugins
  module CaCertificates
    class Action
      class UploadCertificates
        def initialize(app, env)
          @app = app
        end

        def call(env)
          @machine = env[:machine]
          config = @machine.config.ca_certificates

          # All of this tomfoolery to simply upload certificates to the guest. First create
          # the temporary directory and permenant directory for the certificates. After that
          # use elevated privileges to move them into latter directory.
          @machine.communicate.tap do |vm|
            vm.execute('mkdir -p /tmp/vagrant-ca-certificates')
            vm.sudo("mkdir -p #{config.certs_path}")  
            config.certs.each do |from|
              vm.upload(from, "/tmp/vagrant-ca-certificates/#{File.basename(from)}")
            end unless config.certs.length == 0
            vm.sudo("find /tmp/vagrant-ca-certificates -type f -maxdepth 1 -exec mv {} #{config.certs_path}/ \\;")
            vm.sudo('rm -rf /tmp/vagrant-ca-certificates')
          end          

          @app.call(env)
        end
      end
    end
  end
end
