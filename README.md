# Vagrant::CaCertificates

A Vagrant plugin that installs CA certificates onto the virtual machine.

This is useful, for example, in the case where you are behind a corporate proxy server that injects its own self signed SSL certificates when you visit https sites.

## Installation

    vagrant plugin install vagrant-ca-certificates

## Configuration

    config.ca_certificates.enabled = true
    config.ca_certificates.certs = ["/path/to/ca_foo.crt", "/path/to/ca_bar.crt"]

## Installing the plugin locally

```
rm vagrant-ca-certificates-*.gem ; \
vagrant plugin uninstall vagrant-ca-certificates ; \
gem build vagrant-ca-certificates.gemspec && \
vagrant plugin install vagrant-ca-certificates --plugin-source vagrant-ca-certificates-*.gem
```

## Contributing

1. Fork the repository on GitHub
2. Create a named feature branch (i.e. `add-new-feature`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## Authors

- William Bailey - [@cowboysfromhell](https://twitter.com/cowboysfromhell) - ([mail@williambailey.org.uk](mailto:mail@williambailey.org.uk))
- John Bellone - [@johnbellone](https://twitter.com/johnbellone) - ([jbellone@bloomberg.net](mailto:jbellone@bloomberg.net))

## License

Licensed under a [MIT license](LICENSE.txt).
