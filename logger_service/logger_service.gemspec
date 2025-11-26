require_relative "lib/logger_service/version"

Gem::Specification.new do |spec|
  spec.name = "logger_service"
  spec.version = LoggerService::VERSION
  spec.authors = ["Trong Le"]
  spec.email = ["tronglt2001@gmail.com"]

  spec.summary = "A simple event logging service gem."
  spec.description = "A client library for the Event Logging Service that pushes logs to RabbitMQ."
  spec.homepage = "https://example.com/logger_service"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://example.com/logger_service"
  spec.metadata["changelog_uri"] = "https://example.com/logger_service/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bunny"
  spec.add_dependency "json"
end
