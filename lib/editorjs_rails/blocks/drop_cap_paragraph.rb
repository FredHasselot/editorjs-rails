# frozen_string_literal: true

module EditorjsRails
  module Blocks
    # Paragraph opened with a large decorative initial letter (drop cap).
    # Used for the first paragraph of a section to anchor the reader.
    class DropCapParagraph < Base
      BASE_CLASS = "editorjs-drop-cap"

      variants %w[serif-color sans-plain], default: "serif-color"

      attr_reader :text

      def initialize(id:, type:, text: "", variant: nil, **_rest)
        super(id: id, type: type, variant: variant)
        @text = text.to_s
      end

      def to_html
        body = sanitize_inline(@text)
        body = decorate_first_letter(body)

        %(<p class="#{variant_class(BASE_CLASS)}" data-editorial-block="drop_cap_paragraph" data-variant="#{escape_html(@variant)}">#{body}</p>)
      end

      private

      # Wraps the first visible character of the sanitized text with a span.
      # Leading whitespace/tags are preserved so inline formatting still works.
      def decorate_first_letter(sanitized_html)
        # Find the first character that is not part of an HTML tag
        match = sanitized_html.match(/\A(\s*(?:<[^>]+>\s*)*)([[:alpha:]])/)
        return sanitized_html unless match

        prefix = match[1]
        letter = match[2]
        rest = sanitized_html[match.end(0)..] || ""

        prefix + %(<span class="#{BASE_CLASS}__letter">#{letter}</span>) + rest
      end

      def validate
        validate_variant
        @errors << "text cannot be blank" if @text.strip.empty?
      end

      def data_to_h
        { variant: @variant, text: @text }
      end
    end
  end
end
