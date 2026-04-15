# frozen_string_literal: true

module EditorjsRails
  module Blocks
    class Code < Base
      attr_reader :code

      def initialize(id:, type:, code: "", **_rest)
        super(id: id, type: type)
        @code = code.to_s
      end

      def to_html
        %(<pre><code>#{escape_html(code)}</code></pre>)
      end

      private

      def validate
        @errors << "code cannot be blank" if @code.strip.empty?
      end

      def data_to_h
        { code: @code }
      end
    end
  end
end
