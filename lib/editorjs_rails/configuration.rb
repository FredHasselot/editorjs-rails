# frozen_string_literal: true

module EditorjsRails
  class Configuration
    attr_accessor :sanitize, :css_class_prefix, :wrapper_tag

    def initialize
      @sanitize = true
      @css_class_prefix = "editorjs"
      @wrapper_tag = :div
    end

    def register_block(type, klass)
      BlockRegistry.register(type, klass)
    end
  end
end
