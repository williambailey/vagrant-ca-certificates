module VagrantPlugins
  module CaCertificates
    class Action
      class RemoveCertificates
        def initialize(app, env)
          @app = app
        end

        def call(env)
          @machine = env[:machine]
          @machine.sudo('rm -fr /tmp/vagrant-ca-certificates')
          @app.call(env)
        end
      end
    end
  end
end
