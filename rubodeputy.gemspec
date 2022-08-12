# frozen_string_literal: true

require_relative "lib/rubodeputy/version"

Gem::Specification.new do |spec|
  spec.name          = "rubodeputy"
  spec.version       = Rubodeputy::VERSION
  spec.authors       = ["James Childers"]
  spec.email         = ["james.childers@gmail.com"]

  spec.summary       = "Write a short summary, because RubyGems requires one."
  spec.description   = "Write a longer description or delete this line."
  spec.homepage      = "https://www.google.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "http://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jchilders/rubodeputy"
  # spec.metadata["changelog_uri"] = "Put your gem's CHANGELOG.md URL here."

  spec.bindir = "exe"
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.executables << "rubodeputy"
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-system"
  spec.add_dependency "dry-transaction"
  spec.add_dependency "thor"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "rubocop", "~> 1.33"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-rspec"
end
