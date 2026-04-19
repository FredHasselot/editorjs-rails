# frozen_string_literal: true

require "erb"
require "rails-html-sanitizer"

module EditorjsRails
  module Blocks
    class Base
      ALLOWED_INLINE_TAGS = %w[b i em strong a br mark code s u sup sub span].freeze
      ALLOWED_ATTRIBUTES = %w[href target rel class].freeze

      attr_reader :id, :type, :errors, :variant

      class << self
        def variants(list = nil, default: nil)
          if list.nil?
            @variants || []
          else
            @variants = list.map(&:to_s).freeze
            @default_variant = (default || list.first).to_s
          end
        end

        def default_variant
          @default_variant
        end
      end

      def initialize(id:, type:, variant: nil, **_data)
        @id = id
        @type = type
        @variant = normalize_variant(variant)
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

      # Composes a CSS class with the variant suffix when a variant is set.
      # Example: variant_class("editorjs-hero-split") => "editorjs-hero-split editorjs-hero-split--title-above"
      def variant_class(prefix)
        return prefix.to_s if @variant.nil? || @variant.empty?

        "#{prefix} #{prefix}--#{@variant}"
      end

      private

      def normalize_variant(value)
        allowed = self.class.variants
        return nil if allowed.empty?

        candidate = value.to_s
        return candidate if allowed.include?(candidate)

        self.class.default_variant
      end

      def validate
        # Override in subclasses
      end

      def validate_variant
        allowed = self.class.variants
        return if allowed.empty?
        return if allowed.include?(@variant)

        @errors << "variant must be one of: #{allowed.join(', ')}"
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
