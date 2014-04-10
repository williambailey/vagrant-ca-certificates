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

          @machine.sudo('mkdir -p /tmp/vagrant-ca-certificates')
          config.certs.each do |from|
            @machine.upload(from, "/tmp/vagrant-ca-certificates/#{File.basename(from)}")
          end unless config.certs.length == 0

          @app.call(env)
        end
      end
    end
  end
end
