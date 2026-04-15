# frozen_string_literal: true

module EditorjsRails
  module Blocks
    class Image < Base
      ALIGNMENTS = %w[center left right float-left float-right full-width].freeze

      attr_reader :url, :caption, :with_border, :stretched, :with_background, :alignment

      def initialize(id:, type:, url: nil, file: nil, caption: "", withBorder: false,
                     stretched: false, withBackground: false, alignment: "center", **_rest)
        super(id: id, type: type)
        @url = url || (file.is_a?(Hash) ? (file["url"] || file[:url]) : nil)
        @caption = caption.to_s
        @with_border = withBorder
        @stretched = stretched
        @with_background = withBackground
        @alignment = ALIGNMENTS.include?(alignment.to_s) ? alignment.to_s : "center"
      end

      def to_html
        return "" if @url.nil? || @url.to_s.strip.empty?

        html = %(<figure class="#{css_classes}">)
        html += %(<img src="#{escape_html(url)}" alt="#{escape_html(caption)}">)
        html += %(<figcaption>#{sanitize_inline(caption)}</figcaption>) unless @caption.strip.empty?
        html += %(</figure>)
        html
      end

      private

      def validate
        @errors << "url cannot be blank" if @url.nil? || @url.to_s.strip.empty?
      end

      def data_to_h
        {
          url: @url, caption: @caption, withBorder: @with_border,
          stretched: @stretched, withBackground: @with_background,
          alignment: @alignment
        }
      end

      def css_classes
        classes = ["editorjs-image"]
        classes << "editorjs-image--#{@alignment}"
        classes << "editorjs-image--bordered" if @with_border
        classes << "editorjs-image--stretched" if @stretched
        classes << "editorjs-image--background" if @with_background
        classes.join(" ")
      end
    end
  end
end
