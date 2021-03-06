# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snowman-io/version'

Gem::Specification.new do |spec|
  spec.name          = "snowman-io"
  spec.version       = SnowmanIO::VERSION
  spec.authors       = ["Alexey Vakhov", "Artyom Keydunov"]
  spec.email         = ["vakhov@gmail.com"]
  spec.summary       = %q{The heart of snowman}
  spec.description   = %q{SnowmanIO - your personal assistent}
  spec.homepage      = "http://snowman.io"
  spec.license       = "MIT"

  spec.files         = Dir['{bin/*,lib/**/*}'] +
                         %w(LICENSE.txt README.md CHANGELOG.md snowman-io.gemspec)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra", "~> 1.4"
  spec.add_dependency "grape", "~> 0.11.0"
  spec.add_dependency "celluloid", "~> 0.16.0"
  spec.add_dependency "reel", ">= 0.5.0"
  spec.add_dependency "activesupport", "~> 4.1"
  spec.add_dependency "actionmailer", "~> 4.1"
  spec.add_dependency "bcrypt", "~> 3.1"
  spec.add_dependency "nokogiri", "~> 1.6"
  spec.add_dependency "premailer", "~> 1.8"
  spec.add_dependency "mongoid", "~> 4.0.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency 'rerun', '0.10.0'
  spec.add_development_dependency 'timecop', "~> 0.7"
  spec.add_development_dependency 'launchy', "~> 2.4"
  spec.add_development_dependency 'letter_opener', "1.3"
  spec.add_development_dependency 'rack-test', "~> 0.6.3"
end
