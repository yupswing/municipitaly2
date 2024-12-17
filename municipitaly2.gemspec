# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'municipitaly2/version'

Gem::Specification.new do |spec|
  spec.name          = 'municipitaly2'
  spec.version       = Municipitaly2::VERSION
  spec.authors       = %w[yupswing NatyDev]
  spec.email         = ['me@simonecingano.it', 'natydev@aol.com']

  spec.summary       = 'Municipitaly2'
  spec.description   = 'Codes (postal, istat, cadastrian, ...) about Italian ' \
                       'subdivisions and municipalities in Italy [city, cities]'
  spec.homepage      = 'https://github.com/yupswing/municipitaly2'
  spec.license       = 'MIT'
  spec.metadata = {
    'documentation_uri' => 'https://www.rubydoc.info/gems/municipitaly2/2.0.0/Municipitaly2',
    'rubygems_mfa_required' => 'true'
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0")
                     .reject { |f| f.match(%r{^(test|spec|features|tools)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.0.0'

  spec.add_development_dependency 'bundler', '~> 2.5.11'
  spec.add_development_dependency 'rake', '~> 13.2.1'
  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'rubocop', '~> 1.64.1'
  spec.add_development_dependency 'simplecov', '~> 0.22.0'

  spec.add_dependency 'csv', '>= 3.3.0' # removed from stdlib in Ruby 3.4
end
