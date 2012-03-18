# -*- encoding: utf-8 -*-
require 'rake'

Gem::Specification.new do |s|
  s.name          = 'my_stuff-fb303'
  s.version       = '0.0.8'
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Fred Emmott']
  s.email         = ['mail@fredemmott.co.uk']
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/fredemmott/my_stuff-fb303'
  s.summary       = %q{MyStuff.ws's Ruby fb303 implementation}
  s.description   = %q{Basic implementation of fb303 for Ruby services}
  s.license       = 'ISC'
  s.files         = FileList[
    'COPYING',
    'README.rdoc',
    'lib/**/*.rb',
  ].to_a

  s.add_dependency 'thrift'
end
