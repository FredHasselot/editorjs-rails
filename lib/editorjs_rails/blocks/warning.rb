# frozen_string_literal: true

module EditorjsRails
  module Blocks
    class Warning < Base
      attr_reader :title, :message

      def initialize(id:, type:, title: "", message: "", **_rest)
        super(id: id, type: type)
        @title = title.to_s
        @message = message.to_s
      end

      def to_html
        html = %(<div class="editorjs-warning">)
        html += %(<strong>#{escape_html(title)}</strong>) unless @title.strip.empty?
        html += %(<p>#{escape_html(message)}</p>) unless @message.strip.empty?
        html += %(</div>)
        html
      end

      private

      def validate
        @errors << "title or message must be present" if @title.strip.empty? && @message.strip.empty?
      end

      def data_to_h
        { title: @title, message: @message }
      end
    end
  end
end
