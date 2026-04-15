# frozen_string_literal: true

module EditorjsRails
  module Blocks
    class Header < Base
      attr_reader :text, :level

      def initialize(id:, type:, text: "", level: 2, **_rest)
        super(id: id, type: type)
        @text = text.to_s
        @level = level.to_i
      end

      def to_html
        %(<h#{@level}>#{escape_html(text)}</h#{@level}>)
      end

      private

      def validate
        @errors << "text cannot be blank" if @text.strip.empty?
        @errors << "level must be between 1 and 6" unless (1..6).include?(@level)
      end

      def data_to_h
        { text: @text, level: @level }
      end
    end
  end
end
