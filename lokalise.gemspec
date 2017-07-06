# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lokalise/version"

Gem::Specification.new do |spec|
  spec.name          = "lokalise"
  spec.version       = Lokalise::VERSION
  spec.authors       = ["Goutham Pilla", "Sai Chander Ramaram"]
  spec.email         = ["goutham2027@gmail.com", "saichander.ramaram@gmail.com"]

  spec.summary       = %q{gem to wrap lokalise API}
  spec.description   = %q{gem to wrap lokalise API}
  spec.homepage      = "https://gitlab.com/goutham2027/lokalise"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "rest-client"
end
