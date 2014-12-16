Gem::Specification.new do |spec|
  spec.name          = "lita-hipchat_apisend"
  spec.version       = "0.0.1"
  spec.authors       = ["Shu Sugimoto"]
  spec.email         = ["shu@su.gimo.to"]
  spec.description   = %q{hipchat adapter for lita using API for sending messages}
  spec.summary       = %q{extended version of lita hipchat adapter. It adds an ability to send messages via HipChat REST API. You can use additional capabilities provided by API e.g. sending HTML formated messages.}
  spec.homepage      = "https://github.com/s2ugimot/lita-hipchat_apisend"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "adapter" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.0"
  spec.add_runtime_dependency "lita-hipchat", ">= 2.0.1"
  spec.add_runtime_dependency "hipchat"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
