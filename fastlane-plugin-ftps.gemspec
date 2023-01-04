# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/ftps/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-ftps'
  spec.version       = Fastlane::Ftps::VERSION
  spec.author        = %q{Rafał Dziuryk}
  spec.email         = %q{rafal.dziuryk@appvinio.com}

  spec.summary       = %q{Simple ftp upload and download for Fastlane}
  spec.homepage      = "https://github.com/rafaldziuryk/fastlane-ftps-plugin"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'ruby-progressbar'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 2.2.0'
end
