# frozen_string_literal: true

module EditorjsRails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Creates an EditorjsRails initializer"

      def copy_initializer
        copy_file "initializer.rb", "config/initializers/editorjs_rails.rb"
      end
    end
  end
end
