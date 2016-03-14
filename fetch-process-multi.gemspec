# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fetch_process_multi/version'

Gem::Specification.new do |spec|
  spec.name          = 'fetch-process-multi'
  spec.version       = FetchProcessMulti::VERSION
  spec.authors       = ['Karolis Astrauka']
  spec.email         = ['astrauka@gmail.com']

  spec.summary       = %q{Fetch and process multi allows you to calculate and cache multiple values}
  spec.description   = %q{Fetch and process multi allows you to calculate and cache multiple values}
  spec.homepage      = 'https://github.com/vinted/fetch-process-multi'
  spec.licenses      = ['MIT']

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 4.2'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rails', '~> 4.2'
  spec.add_development_dependency 'rspec', '~> 3.4'
end
