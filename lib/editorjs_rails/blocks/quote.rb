# frozen_string_literal: true

module EditorjsRails
  module Blocks
    class Quote < Base
      attr_reader :text, :caption, :alignment

      def initialize(id:, type:, text: "", caption: "", alignment: "left", **_rest)
        super(id: id, type: type)
        @text = text.to_s
        @caption = caption.to_s
        @alignment = alignment.to_s
      end

      def to_html
        html = %(<blockquote>#{escape_html(text)})
        html += %(<cite>#{escape_html(caption)}</cite>) unless @caption.strip.empty?
        html += %(</blockquote>)
        html
      end

      private

      def validate
        @errors << "text cannot be blank" if @text.strip.empty?
      end

      def data_to_h
        { text: @text, caption: @caption, alignment: @alignment }
      end
    end
  end
end
