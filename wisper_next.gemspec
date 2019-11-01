lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "wisper_next/version"

Gem::Specification.new do |spec|
  spec.name          = "wisper_next"
  spec.version       = WisperNext::VERSION
  spec.authors       = ["Kris Leech"]
  spec.email         = ["kris.leech@gmail.com"]

  spec.summary       = "A micro library providing Ruby objects with Publish-Subscribe capabilities"
  spec.description   = "A micro library providing Ruby objects with Publish-Subscribe capabilities"
  spec.homepage      = "https://gitlab.com/kris.leech/wisper_next"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://gitlab.com/kris.leech/wisper_next/blob/master/CHANGELOG.md"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
