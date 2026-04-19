# frozen_string_literal: true

require_relative "editorjs_rails/version"
require_relative "editorjs_rails/blocks/base"
require_relative "editorjs_rails/blocks/paragraph"
require_relative "editorjs_rails/blocks/header"
require_relative "editorjs_rails/blocks/list"
require_relative "editorjs_rails/blocks/quote"
require_relative "editorjs_rails/blocks/delimiter"
require_relative "editorjs_rails/blocks/code"
require_relative "editorjs_rails/blocks/table"
require_relative "editorjs_rails/blocks/image"
require_relative "editorjs_rails/blocks/warning"
require_relative "editorjs_rails/blocks/checklist"
# Editorial blocks (opt-in, not registered by default — apps call config.register_block)
require_relative "editorjs_rails/blocks/hero_split"
require_relative "editorjs_rails/blocks/drop_cap_paragraph"
require_relative "editorjs_rails/blocks/pull_quote"
require_relative "editorjs_rails/blocks/image_with_caption"
require_relative "editorjs_rails/blocks/asymmetric_gallery"
require_relative "editorjs_rails/block_registry"
require_relative "editorjs_rails/document"
require_relative "editorjs_rails/configuration"
require_relative "editorjs_rails/helper"
require_relative "editorjs_rails/form_builder"
require_relative "editorjs_rails/i18n_helper"

module EditorjsRails
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset!
      @configuration = Configuration.new
      BlockRegistry.reset!
    end
  end
end

EditorjsRails::BlockRegistry.register_defaults

require_relative "editorjs_rails/engine" if defined?(Rails::Engine)
