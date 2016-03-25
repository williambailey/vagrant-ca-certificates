# CA Certificate Plugin for Vagrant
![Gem Version](https://img.shields.io/gem/v/vagrant-ca-certificates.svg)
![Build Status](https://img.shields.io/travis/williambailey/vagrant-ca-certificates.svg)
![License](https://img.shields.io/github/license/williambailey/vagrant-ca-certificates.svg)

A [Vagrant][4] plugin which configures the virtual machine to inject
the specified certificates into the guest's root bundle. This is
useful, for example, if your enterprise network has a firewall (or
appliance) which utilizes [SSL interception][5].

_Warning:_ This plugin adds certificates to the guest operating
system's [root certificate bundle][6]. You should only use this if you
know *exactly* what you are doing. This should *never* be used on a
production machine.

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
`~/.vagrant.d/Vagrantfile`. This will be merged into the final
Vagrantfile configuration that the test-kitchen run will use to
provision a new instance.
```ruby
Vagrant.configure('2') do |config|
  config.proxy.enabled = true if Vagrant.has_plugin?('vagrant-proxyconf')

  if Vagrant.has_plugin?('vagrant-ca-certificates')
    config.ca_certificates.enabled = true
    config.ca_certificates.certs = [
      '/etc/pki/ca-trust/source/anchors/root.crt',
      '/etc/pki/ca-trust/source/anchors/sub.crt'
    ]
  end
end
```
### Writing a .kitchen.local.yml
One goal that we set out when creating internal cookbooks is if that
they can be open sourced we want to be easily able to do so in the
future. That means we try to keep out as much of our environment
specific variables, such as proxy configuration, from the repository's
base kitchen configuration. Luckily test-kitchen merges in a local
file, if it exists, at the time of the run.

Here is an example of the local configuration file that we use to
merge in the Vagrantfile that we've created in the above example. This
can be saved into `$HOME/.kitchen/config.yml` to be applied to *all*
test-kitchen runs for this user (on this host machine).
```yaml
---
driver:
    provision: true
    http_proxy: "http://proxy.corporate.com:80"
    https_proxy: "http://proxy.corporate.com:80"
    ftp_proxy: "http://proxy.corporate.com:80"
    no_proxy: "localhost,127.0.0.1"
```

## Vagrant Configuration
If you're just looking to inject the certificate *only for a single
Vagrantfile* then you can simply use the following block anywhere
within the Vagrant configuration. This enables the plugin and injects
the specified certificates.

```ruby
Vagrant.configure('2') do |config|
  if Vagrant.has_plugin?('vagrant-ca-certificates')
    config.ca_certificates.enabled = true
    config.ca_certificates.certs = Dir.glob('/etc/pki/ca-trust/source/anchors/*.crt')
  end
end
```
### System Wide
At [Bloomberg][1] we often find ourselves in a situation where we do
not want to make modifications to open source tools, but we need them
to work within our enterprise network. Using this default base configuration
for Vagrant we're able to ensure that all runs will inject the appropriate
certificates into the guest.

Additionally if you need proxies modified in the guest as well an
excellent choice is the [Vagrant Proxyconf plugin][2] which should
handle everything you'll run into on a daily basis. Finally, we add the
[Vagrant cachier plugin][7] so that we are not continually going out to the Internet
on successive [Test Kitchen][3] and Vagrant runs.

This file should be saved to `$HOME/.kitchen/Vagrantfile.rb`.
```ruby
# These are requirements for this base Vagrantfile. If they are not
# installed there will be a warning message with Vagrant/test-kitchen.
%w(vagrant-ca-certificates vagrant-proxyconf vagrant-cachier).each do |name|
  fail "Please install the '#{name}' plugin!" unless Vagrant.has_plugin?(name)
end

Vagrant.configure('2') do |config|
  config.cache.scope = :box
  config.proxy.enabled = true
  config.ca_certificates.enabled = true
  config.ca_certificates.certs = Dir.glob('/etc/pki/ca-trust/source/anchors/*.crt')
end
```
[1]: https://careers.bloomberg.com
[2]: https://github.com/tmatilai/vagrant-proxyconf
[3]: https://github.com/test-kitchen/test-kitchen
[4]: https://github.com/mitchellh/vagrant
[5]: http://en.wikipedia.org/wiki/Man-in-the-middle_attack
[6]: http://en.wikipedia.org/wiki/Root_certificate
[7]: https://github.com/fgrehm/vagrant-cachier
