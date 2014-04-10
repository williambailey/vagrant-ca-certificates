require 'vagrant'
require_relative '../logger'

module VagrantPlugins
  module CaCertificates
    class Action
      class UpdateCertificates
        def initialize(app, env)
          @app = app
        end

        def call(env)
          @machine = env[:machine]
          
          if @machine.guest.capability?(:update_certificates)
            @machine.guest.capability(:update_certificates)  
          end
        end
      end
    end
  end
end
