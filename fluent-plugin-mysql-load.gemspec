# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-mysql-load"
  spec.version       = "0.0.2"
  spec.authors       = ["Fukui ReTu"]
  spec.email         = ["s0232101@gmail.com"]
  spec.description   = %q{BufferedOutput plugin to mysql import}
  spec.summary       = %q{BufferedOutput plugin to mysql import}
  spec.homepage      = "https://github.com/fukuiretu/fluent-plugin-mysql-load"
  spec.license       = "APL2.0"

  spec.rubyforge_project = "fluent-plugin-mysql-load"
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "fluentd"
  spec.add_runtime_dependency "mysql2"
end
