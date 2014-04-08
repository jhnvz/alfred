# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alfred_rails/version'

Gem::Specification.new do |gem|
  gem.name          = "alfred_rails"
  gem.version       = Alfred::VERSION
  gem.authors       = ['Johan van Zonneveld', 'Arjen Oosterkamp']
  gem.email         = ['johan@vzonneveld.nl', 'mail@arjen.me']
  gem.homepage      = 'https://github.com/jhnvz/alfred_rails.git'
  gem.summary       = %q{Serves controller responses under several conditions.}
  gem.description   = %q{Alfred creates fixture files of your controller responses so you can use them in your tests. Ideal if your app's client is build with a javascript framework and you want to test responses under several conditions.}
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = ["alfred"]
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '>= 1.0.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'rspec', '>= 2.3'
  gem.add_development_dependency 'rspec-rails', '~> 2.0'
  gem.add_development_dependency 'batman-rails'
  gem.add_development_dependency 'sqlite3'

  gem.add_development_dependency 'teaspoon'
  gem.add_development_dependency 'coffee-script'

  gem.add_dependency 'database_cleaner'
  gem.add_dependency 'ruby-progressbar'
  gem.add_dependency 'ammeter'

  if RUBY_VERSION > '1.9.2'
    gem.add_dependency 'rails', '>= 3.2.0'
  else
    gem.add_dependency 'rails', '>= 3.2.0', '< 4.0.0'
  end

  if File.exists?('UPGRADING')
    gem.post_install_message = File.read("UPGRADING")
  end
end
