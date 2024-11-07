# frozen_string_literal: true

require_relative "lib/mock/twilio/version"

Gem::Specification.new do |spec|
  spec.name = "mock-twilio"
  spec.version = Mock::Twilio::VERSION
  spec.authors = ['SchoolStatus Platform Team']
  spec.summary = "This repository contains Mock::Twilio::Client and Webhooks for Twilio's API."
  spec.description = "This repository contains Mock::Twilio::Client for Twilio's API."
  spec.homepage = "https://github.com/schoolstatus/mock-twilio"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/schoolstatus/mock-twilio"
  spec.metadata["changelog_uri"] = "https://github.com/schoolstatus/mock-twilio/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "faraday", ">= 2.9.1"
  spec.add_dependency "rufus-scheduler", ">= 3.9.1"
  spec.add_dependency "twilio-ruby", ">= 7.0.0"
  spec.add_dependency "activesupport", ">= 6.0.0"
  spec.add_dependency "rack", ">= 3.1.8"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
