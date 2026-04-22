# frozen_string_literal: true

module EditorjsRails
  module Blocks
    # Editorial image + styled caption, richer than the standard Image block.
    # Variants:
    #   - below-small-caps : caption below image, small caps with letter-spacing
    #   - side             : caption to the right of the image (desktop); stacks on mobile
    #   - overlay          : caption overlaid at the bottom of the image with gradient scrim
    class ImageWithCaption < Base
      BASE_CLASS = "editorjs-image-caption"

      variants %w[below-small-caps side overlay], default: "below-small-caps"

      attr_reader :image_url, :image_alt, :image_id, :image_bordered, :image_background, :caption, :credit

      def initialize(id:, type:, image: nil, caption: "", credit: "", variant: nil, **_rest)
        super(id: id, type: type, variant: variant)
        image_data = image.is_a?(Hash) ? image : {}
        @image_url = (image_data[:url] || image_data["url"]).to_s
        @image_alt = (image_data[:alt] || image_data["alt"]).to_s
        @image_id = image_data[:id] || image_data["id"]
        @image_bordered = truthy?(image_data[:bordered] || image_data["bordered"])
        @image_background = truthy?(image_data[:background] || image_data["background"])
        @caption = caption.to_s
        @credit = credit.to_s
      end

      def to_html
        id_attr = @image_id ? %( data-image-id="#{escape_html(@image_id)}") : ""
        modifier_classes = []
        modifier_classes << "editorjs-image--bordered" if @image_bordered
        modifier_classes << "editorjs-image--background" if @image_background
        class_attr = [variant_class(BASE_CLASS), *modifier_classes].join(" ")
        html = %(<figure class="#{class_attr}" data-editorial-block="image_with_caption" data-variant="#{escape_html(@variant)}">)
        html += %(<img src="#{escape_html(@image_url)}" alt="#{escape_html(@image_alt)}"#{id_attr}>)
        html += caption_html
        html += %(</figure>)
        html
      end

      private

      def caption_html
        return "" if @caption.strip.empty? && @credit.strip.empty?

        parts = []
        parts << %(<span class="#{BASE_CLASS}__caption">#{sanitize_inline(@caption)}</span>) unless @caption.strip.empty?
        parts << %(<span class="#{BASE_CLASS}__credit">#{sanitize_inline(@credit)}</span>) unless @credit.strip.empty?
        %(<figcaption class="#{BASE_CLASS}__figcaption">#{parts.join}</figcaption>)
      end

      def validate
        validate_variant
        @errors << "image url cannot be blank" if @image_url.strip.empty?
      end

      def data_to_h
        image = {
          url: @image_url, alt: @image_alt,
          bordered: @image_bordered, background: @image_background
        }
        image[:id] = @image_id if @image_id
        {
          variant: @variant,
          image: image,
          caption: @caption,
          credit: @credit
        }
      end

      def truthy?(value)
        value == true || value == "true" || value == 1 || value == "1"
      end
    end
  end
end
