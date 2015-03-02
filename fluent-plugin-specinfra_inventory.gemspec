# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent/plugin/specinfra_inventory/version'

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-specinfra_inventory"
  spec.version       = Fluent::Plugin::SpecinfraInventory::VERSION
  spec.authors       = ["Masashi Terui"]
  spec.email         = ["marcy9114@gmail.com"]
  spec.summary       = %q{Specinfra Host Inventory Plugin for Fluentd}
  spec.description   = %q{Specinfra Host Inventory Plugin for Fluentd}
  spec.homepage      = "https://github.com/marcy-terui/fluent-plugin-specinfra_inventory"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "fluentd"
  spec.add_dependency "specinfra", ">= 2.17.1"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "coveralls"
end
