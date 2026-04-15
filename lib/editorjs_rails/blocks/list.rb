# frozen_string_literal: true

module EditorjsRails
  module Blocks
    class List < Base
      attr_reader :style, :items

      def initialize(id:, type:, style: "unordered", items: [], **_rest)
        super(id: id, type: type)
        @style = style.to_s
        @items = Array(items)
      end

      def to_html
        tag = @style == "ordered" ? "ol" : "ul"
        items_html = render_items(@items)
        %(<#{tag}>#{items_html}</#{tag}>)
      end

      private

      def validate
        @errors << "style must be 'ordered' or 'unordered'" unless %w[ordered unordered].include?(@style)
        @errors << "items cannot be empty" if @items.empty?
      end

      def data_to_h
        { style: @style, items: @items }
      end

      def render_items(items)
        items.map do |item|
          if item.is_a?(Hash)
            content = sanitize_inline(item["content"] || item[:content] || "")
            nested = item["items"] || item[:items] || []
            if nested.any?
              nested_tag = @style == "ordered" ? "ol" : "ul"
              %(<li>#{content}<#{nested_tag}>#{render_items(nested)}</#{nested_tag}></li>)
            else
              %(<li>#{content}</li>)
            end
          else
            %(<li>#{sanitize_inline(item)}</li>)
          end
        end.join
      end
    end
  end
end
