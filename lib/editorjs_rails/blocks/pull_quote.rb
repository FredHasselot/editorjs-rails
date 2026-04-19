# frozen_string_literal: true

module EditorjsRails
  module Blocks
    # Editorial pull quote — a standout quotation outside the main text flow.
    # Three visual variants:
    #   - colored-panel : coloured background block with white text
    #   - big-quotes    : oversize decorative serif quote marks flanking the text
    #   - left-border   : thick coloured vertical rule on the left, italic text
    class PullQuote < Base
      BASE_CLASS = "editorjs-pull-quote"

      variants %w[colored-panel big-quotes left-border], default: "colored-panel"

      attr_reader :text, :attribution

      def initialize(id:, type:, text: "", attribution: "", variant: nil, **_rest)
        super(id: id, type: type, variant: variant)
        @text = text.to_s
        @attribution = attribution.to_s
      end

      def to_html
        html = %(<figure class="#{variant_class(BASE_CLASS)}" data-editorial-block="pull_quote" data-variant="#{escape_html(@variant)}">)
        html += %(<blockquote class="#{BASE_CLASS}__text">#{sanitize_inline(@text)}</blockquote>)
        html += %(<figcaption class="#{BASE_CLASS}__attribution">#{sanitize_inline(@attribution)}</figcaption>) unless @attribution.strip.empty?
        html += %(</figure>)
        html
      end

      private

      def validate
        validate_variant
        @errors << "text cannot be blank" if @text.strip.empty?
      end

      def data_to_h
        { variant: @variant, text: @text, attribution: @attribution }
      end
    end
  end
end
