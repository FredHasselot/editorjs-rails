# frozen_string_literal: true

module EditorjsRails
  class BlockRegistry
    class << self
      def registry
        @registry ||= {}
      end

      def register(type, klass)
        registry[type.to_s] = klass
      end

      def build(type, id, data)
        klass = registry[type.to_s]
        return nil unless klass

        klass.new(id: id, type: type.to_s, **data.transform_keys(&:to_sym))
      end

      def registered?(type)
        registry.key?(type.to_s)
      end

      def reset!
        @registry = {}
        register_defaults
      end

      def register_defaults
        register("paragraph", Blocks::Paragraph)
        register("header", Blocks::Header)
        register("list", Blocks::List)
        register("quote", Blocks::Quote)
        register("delimiter", Blocks::Delimiter)
        register("code", Blocks::Code)
        register("table", Blocks::Table)
        register("image", Blocks::Image)
        register("warning", Blocks::Warning)
        register("checklist", Blocks::Checklist)
      end
    end
  end
end
