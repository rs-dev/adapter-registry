# -*- encoding: utf-8 -*-

require File.join(File.dirname(__FILE__), 'lib', 'adapter-registry', 'version')

require 'date'

Gem::Specification.new do |s|
  s.name = "adapter-registry"
  s.version = AdapterRegistry::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andreas Kopecky <andreas.kopecky@radarservices.com>", "Anton Bangratz <anton.bangratz@radarservices.com>", "Martin Natano <martin.natano@radarservices.com"]
  s.date = Date.today.strftime
  s.description = "Simple adapter registry"
  s.email = "gems [a] radarservices [d] com"
  s.files            = `git ls-files`.split("\n").reject { |file| file == '.gitignore' }
  s.extra_rdoc_files = %w[LICENSE README.md]

  s.homepage = "http://github.com/rs-dev/adapter-registry"
  s.require_paths = ["lib"]
  # s.rubygems_version = "1.8.24"
  s.summary = "Simple adapter registry for enhancing classes via adapters"
  s.license = "ISC"
end
