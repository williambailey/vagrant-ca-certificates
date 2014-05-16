# Vagrant::CaCertificates

A Vagrant plugin that installs CA certificates onto the virtual machine.

This is useful, for example, in the case where you are behind a corporate
proxy server that injects its own self signed SSL certificates when you
visit https sites.

## Installation

```bash
vagrant plugin install vagrant-ca-certificates
```

## Configuration

```ruby
config.ca_certificates.enabled = true
config.ca_certificates.certs = [
  "/path/to/ca_foo.crt",
  "/path/to/ca_bar.crt",
  "http://example.com/ca_baz.crt"
]
```

As shown above certificates can sourced from the local file system or
via http(s).

The Vagrant plugin expects the certificates to be in encoded using the
PEM format. They are Base64 encoded ASCII files and contain
`-----BEGIN CERTIFICATE-----` and `-----END CERTIFICATE-----` statements.

## Installing the plugin locally

```bash
rm pkg/*.gem ; \
vagrant plugin uninstall vagrant-ca-certificates ; \
rake build && \
vagrant plugin install pkg/*.gem
```

## Contributing

1. Fork the repository on GitHub
2. Create a named feature branch (i.e. `add-new-feature`)
3. Write your change
4. Submit a Pull Request

## Authors

- William Bailey - [@cowboysfromhell](https://twitter.com/cowboysfromhell) - ([mail@williambailey.org.uk](mailto:mail@williambailey.org.uk))
- John Bellone - [@johnbellone](https://twitter.com/johnbellone) - ([jbellone@bloomberg.net](mailto:jbellone@bloomberg.net))

## License

Licensed under a [MIT license](LICENSE.txt).
