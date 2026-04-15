# frozen_string_literal: true

module EditorjsRails
  module Blocks
    class Paragraph < Base
      attr_reader :text

      def initialize(id:, type:, text: "", **_rest)
        super(id: id, type: type)
        @text = text.to_s
      end

      def to_html
        %(<p>#{sanitize_inline(text)}</p>)
      end

      private

      def validate
        @errors << "text cannot be blank" if @text.strip.empty?
      end

      def data_to_h
        { text: @text }
      end
    end
  end
end
