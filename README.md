# Vagrant::CaCertificates
Vagrant plugin which installs trusted CA certificates into a guest.

This is useful, for example, in the case where you are behind a corporate
firewall appliance which performs SSL interception and supplies its own
self-signed certificate. It also is useful in cases where your enterprise
has a split-horizon certificate authority for internal sites.

## Installation
The latest stable version of this plugin can be installed using the
standard `vagrant plugin install` with the `vagrant-ca-certificates`
argument. If you're looking to hack on the plugin or test a
development release you'll need to checkout the branch and build the
gem yourself. That's pretty easy.

The following set of commands checks out the master branch, uses
bundler to install all of the Ruby dependencies and finally creates
the gem locally. Once the gem is built we use the Vagrant command-line
tool to install it.
```sh
git clone https://github.com/williambailey/vagrant-ca-certificates ~/Projects/vagrant-ca-certificates
cd ~/Projects/vagrant-ca-certificates
bundle install
rake build
vagrant plugin install pkg/vagrant-ca-certificates-*.gem
```

## Using with Test Kitchen
### Writing a Vagrantfile.rb
In order to be able to use [test kitchen][2] within an environment that
has a HTTP proxy with SSL interception we need to ensure that we set
both the proxies and inject in our new certificate bundles.

If you're following the complete tutorial here we're going to save
this file in a newly created directory
`~/.kitchen.d/Vagrantfile.rb`. This will be merged into the final
Vagrantfile configuration that the test-kitchen run will use to
provision a new instance.
```ruby
# These are requirements for this base Vagrantfile. If they are not
# installed there will be a warning message with Vagrant/test-kitchen.
%w(vagrant-ca-certificates vagrant-proxyconf).each do |name|
  fail "Please install the '#{name}' plugin!" unless Vagrant.has_plugin?(name)
end

Vagrant.configure('2') do |config|
  config.proxy.enabled = true
  config.ca_certificates.enabled = true
  config.ca_certificates.certs = [
    '/etc/pki/ca-trust/source/anchors/root.crt',
    '/etc/pki/ca-trust/source/anchors/sub.crt'
  ]
end
```
### Writing a .kitchen.local.yml
One goal that we set out when creating internal cookbooks is if that
they can be open sourced we want to be easily able to do so in the
future. That means we try to keep out as much of our environment
specific variables, such as proxy configuration, from the repository's
base kitchen configuration. Luckily test-kitchen merges in a local
file, if it exists, at the time of the run.

Here is an example of the local configuration file that we use to merge
in the Vagrantfile that we've created in the above example.
```yaml
---
driver:
    provision: true
    vagrantfiles:
        - "/home/kitchen/.kitchen.d/Vagrantfile"
provisioner:
    http_proxy: "http://proxy.corporate.com:80"
    https_proxy: "http://proxy.corporate.com:80"
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

## Authors
- William Bailey - [@cowboysfromhell](https://twitter.com/cowboysfromhell) - ([mail@williambailey.org.uk](mailto:mail@williambailey.org.uk))
- John Bellone - [@johnbellone](https://twitter.com/johnbellone) - ([jbellone@bloomberg.net](mailto:jbellone@bloomberg.net))

## License
Licensed under a [MIT license](LICENSE.txt).
