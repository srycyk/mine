# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mine/version"

Gem::Specification.new do |spec|
  spec.name          = "mine"
  spec.version       = Mine::VERSION
  spec.authors       = ["Stephen Rycyk"]
  spec.email         = ["stephen.rycyk@gmail.com"]

  spec.summary       = %q{Scrapes data from websites.}
  spec.description   = %q{Structured solution to fetch and extract data from web pages.}
  spec.homepage      = "http://github.com/srycyk/mine"
  spec.license       = "MIT"

=begin
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end
=end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
                         f.match(%r{^(spec|features)/})
                       end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  #spec.add_development_dependency "nokogiri", "-> 1.8"
  spec.add_dependency "nokogiri", "1.8"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
