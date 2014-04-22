module VagrantPlugins
  module CaCertificates
    class Action
      # Action which checks if the plugin should be enabled
      class IsEnabled
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:result] = plugin_enabled?(env[:machine].config.ca_certificates)
          if !env[:result] then
            env[:ui].info I18n.t("vagrant_ca_certificates.not_enabled")
          end
          @app.call(env)
        end

        private

        def plugin_enabled?(config)
          config.enabled != false && config.enabled != ''
        end
      end
    end
  end
end
