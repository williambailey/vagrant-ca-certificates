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
            env[:ui].info I18n.t("vagrant_ca_certificates.certificate.update.pre")
            @machine.guest.capability(:update_certificates)  
            env[:ui].info I18n.t("vagrant_ca_certificates.certificate.update.post")
          else
            env[:ui].error I18n.t("vagrant_ca_certificates.certificate.update.not_supported")
          end
        end
      end
    end
  end
end
