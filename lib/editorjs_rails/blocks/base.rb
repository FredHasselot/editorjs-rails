# frozen_string_literal: true

require "erb"
require "rails-html-sanitizer"

module EditorjsRails
  module Blocks
    class Base
      ALLOWED_INLINE_TAGS = %w[b i em strong a br mark code s u sup sub span].freeze
      ALLOWED_ATTRIBUTES = %w[href target rel class].freeze

      attr_reader :id, :type, :errors

      def initialize(id:, type:, **_data)
        @id = id
        @type = type
        @errors = []
      end

      def valid?
        @errors = []
        validate
        @errors.empty?
      end

      def to_html
        raise NotImplementedError, "#{self.class}#to_html must be implemented"
      end

      def to_h
        { id: @id, type: @type, data: data_to_h }
      end

      private

      def validate
        # Override in subclasses
      end

      def data_to_h
        raise NotImplementedError, "#{self.class}#data_to_h must be implemented"
      end

      # Sanitize inline HTML — allows bold, italic, links, br, etc.
      # Blocks script, iframe, and other dangerous tags.
      def sanitize_inline(str)
        Rails::HTML5::SafeListSanitizer.new.sanitize(
          str.to_s,
          tags: ALLOWED_INLINE_TAGS,
          attributes: ALLOWED_ATTRIBUTES
        )
      end

      # Full escape — no HTML allowed (for code blocks, etc.)
      def escape_html(str)
        ERB::Util.h(str.to_s)
      end
    end
  end
end
