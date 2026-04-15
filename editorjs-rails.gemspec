# frozen_string_literal: true

require_relative "lib/editorjs_rails/version"

Gem::Specification.new do |spec|
  spec.name = "editorjs-rails"
  spec.version = EditorjsRails::VERSION
  spec.authors = ["Fred Hasselot"]
  spec.email = ["fred.hasselot@gmail.com"]

  spec.summary = "EditorJS integration for Ruby on Rails"
  spec.description = "Block-based content editor for Rails. Renders EditorJS JSON to HTML server-side, " \
                     "provides a Stimulus controller, form builder helper, and dark mode theming."
  spec.homepage = "https://github.com/fredhasselot/editorjs-rails"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    Dir["{lib,spec}/**/*", "LICENSE.txt", "README.md", "CHANGELOG.md", "Rakefile"]
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "actionview", ">= 7.0"
  spec.add_dependency "activesupport", ">= 7.0"
end
