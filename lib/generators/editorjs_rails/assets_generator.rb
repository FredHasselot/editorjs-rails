# frozen_string_literal: true

module EditorjsRails
  module Generators
    class AssetsGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Copies EditorJS Stimulus controller and CSS to your app"

      def copy_stimulus_controller
        copy_file "editorjs_controller.js", "app/javascript/controllers/editorjs_controller.js"
      end

      def copy_stylesheet
        copy_file "editorjs.css", "app/assets/stylesheets/editorjs.css"
      end

      def show_npm_instructions
        say ""
        say "Install the required npm packages:", :green
        say "  npm install @editorjs/editorjs @editorjs/header @editorjs/list @editorjs/quote @editorjs/delimiter"
        say ""
        say "Then register the Stimulus controller in your controllers/index.js:", :green
        say '  import EditorjsController from "./editorjs_controller"'
        say '  application.register("editorjs", EditorjsController)'
        say ""
      end
    end
  end
end
