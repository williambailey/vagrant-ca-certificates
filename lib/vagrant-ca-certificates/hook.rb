require 'vagrant'

module VagrantPlugins
  module CaCertificates
    class Plugin < Vagrant.plugin('2')
      # Actions to run before any provisioner or other plugin
      action_hook 'ca_certificates_configure' do |hook|
        require_relative 'action'

        # the standard provision action
        hook.after Vagrant::Action::Builtin::Provision, Action.configure

        # Vagrant 1.5+ can install NFS client
        if check_vagrant_version('>= 1.5.0.dev')
          hook.after Vagrant::Action::Builtin::SyncedFolders, Action.configure
        end

        # configure the certificates before vagrant-omnibus
        if defined?(VagrantPlugins::Omnibus::Action::InstallChef)
          hook.after VagrantPlugins::Omnibus::Action::InstallChef, Action.configure
        end

      end
    end
  end
end
