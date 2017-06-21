# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omnihooks-core-warehouse/version'

Gem::Specification.new do |spec|
  spec.name          = "omnihooks-core-warehouse"
  spec.version       = Omnihooks::CoreWarehouse::VERSION
  spec.authors       = ["Karl Falconer"]
  spec.email         = ["karl@getdropstream.com"]

  spec.summary       = %q{Omnihooks Strategy for CoreWarehouse Webhooks}
  spec.description   = %q{Omnihooks Strategy for CoreWarehouse Webhooks}
  spec.homepage      = "https://github.com/dropstream/omnihooks-core-warehouse"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]
  spec.add_dependency 'omnihooks', '~> 0.0.2'
  spec.add_dependency 'activesupport', '>= 3.1'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
