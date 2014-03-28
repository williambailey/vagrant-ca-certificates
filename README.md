# Vagrant::CaCertificates

Vagrant plugin that allows you to install custom CS certificates

## Installation

	vagrant plugin install vagrant-ca-certificates

## Configuration

    config.ca_certificates.enabled = true
    config.ca_certificates.certs = ["/path/to/ca_foo.crt", "/path/to/ca_bar.crt"]
