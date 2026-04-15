# frozen_string_literal: true

module EditorjsRails
  class Engine < ::Rails::Engine
    isolate_namespace EditorjsRails

    initializer "editorjs_rails.helper" do
      ActiveSupport.on_load(:action_view) do
        include EditorjsRails::Helper
      end
    end

    initializer "editorjs_rails.form_builder" do
      ActiveSupport.on_load(:action_view) do
        ActionView::Helpers::FormBuilder.include EditorjsRails::FormBuilder
      end
    end
  end
end
