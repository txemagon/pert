# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pert/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["txemagon"]
  gem.email         = ["txema.gonz@gmail.com"]
  gem.description   = %q{Creates PERT diagramas using a task file.}
  gem.summary       = %q{Create a task file giving the name of a task, the tasks it depends on and a duration and get the PERT diagram in dot language. }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pert"
  gem.require_paths = ["lib"]
  gem.version       = Pert::VERSION
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('aruba')
  gem.add_development_dependency('rake', '~> 0.9.2')
  gem.add_dependency('methadone', '~> 1.2.6')
end
