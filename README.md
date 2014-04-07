# Vagrant::CaCertificates

Vagrant plugin that allows you to install custom CA certificates

## Installation

    vagrant plugin install vagrant-ca-certificates --plugin-source http://rubygems.dev.bloomberg.com/

## Configuration

    config.ca_certificates.enabled = true
    config.ca_certificates.certs = ["/path/to/ca_foo.crt", "/path/to/ca_bar.crt"]

## Installing the plugin locally

    $ vagrant plugin uninstall vagrant-ca-certificates
    $ gem build vagrant-ca-certificates.gemspec
    $ vagrant plugin install vagrant-ca-certificates --plugin-source vagrant-ca-certificates-0.0.1.gem
