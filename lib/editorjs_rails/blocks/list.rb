# frozen_string_literal: true

module EditorjsRails
  module Blocks
    class List < Base
      attr_reader :style, :items

      def initialize(id:, type:, style: "unordered", items: [], meta: nil, **_rest)
        super(id: id, type: type)
        @style = style.to_s
        @items = Array(items)
      end

      def to_html
        if checklist?
          render_checklist(@items)
        else
          tag = @style == "ordered" ? "ol" : "ul"
          %(<#{tag}>#{render_items(@items)}</#{tag}>)
        end
      end

      private

      def checklist?
        @style == "checklist"
      end

      def validate
        @errors << "style must be 'ordered', 'unordered', or 'checklist'" unless %w[ordered unordered checklist].include?(@style)
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

      def render_checklist(items)
        items_html = items.map do |item|
          if item.is_a?(Hash)
            content = sanitize_inline(item["content"] || item[:content] || "")
            meta = item["meta"] || item[:meta] || {}
            checked = meta["checked"] || meta[:checked]
            checked_attr = checked ? " checked" : ""
            %(<li><label><input type="checkbox" disabled#{checked_attr}> #{content}</label></li>)
          else
            %(<li><label><input type="checkbox" disabled> #{sanitize_inline(item)}</label></li>)
          end
        end.join
        %(<ul class="editorjs-checklist">#{items_html}</ul>)
      end
    end
  end
end
