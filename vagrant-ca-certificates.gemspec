# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-ca-certificates/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-ca-certificates"
  spec.version       = VagrantPlugins::CaCertificates::VERSION
  spec.authors       = ["William Bailey", "John Bellone"]
  spec.email         = ["mail@williambailey.org.uk", "jbellone@bloomberg.net"]
  spec.summary       = "A Vagrant plugin that installs CA certificates onto the virtual machine."
  spec.description   = <<-EOF
    A Vagrant plugin that installs CA certificates onto the virtual machine.
    This is useful, for example, in the case where you are behind a corporate proxy
    server that injects its own self signed SSL certificates when you visit https sites.
  EOF
  spec.homepage      = "https://github.com/williambailey/vagrant-ca-certificates"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'stickler', '~> 2.4.0'
end
