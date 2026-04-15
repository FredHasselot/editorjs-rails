# frozen_string_literal: true

module EditorjsRails
  module Blocks
    class Delimiter < Base
      def initialize(id:, type:, **_rest)
        super(id: id, type: type)
      end

      def to_html
        "<hr>"
      end

      private

      def data_to_h
        {}
      end
    end
  end
end
