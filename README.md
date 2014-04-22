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

Copyright (c) 2014 William Bailey (<mail@williambailey.org.uk>)
Copyright (c) 2014 John Bellone (<john.bellone.jr@gmail.com>)
Copyright (c) 2014 Bloomberg Finance L.P.

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
