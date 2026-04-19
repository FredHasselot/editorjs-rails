# frozen_string_literal: true

module EditorjsRails
  module Blocks
    # Asymmetric gallery — 2 to 4 images in a composed layout, not a uniform grid.
    # Variants:
    #   - triptyque       : 3 images (1 large + 2 stacked)
    #   - duo-offset      : 2 images, vertically offset and overlapping
    #   - collage-rotated : 3-4 images with subtle rotations (polaroid feel)
    class AsymmetricGallery < Base
      BASE_CLASS = "editorjs-gallery"

      variants %w[triptyque duo-offset collage-rotated], default: "triptyque"

      MIN_MAX_IMAGES = {
        "triptyque" => (3..3),
        "duo-offset" => (2..2),
        "collage-rotated" => (3..4)
      }.freeze

      attr_reader :images

      def initialize(id:, type:, images: [], variant: nil, **_rest)
        super(id: id, type: type, variant: variant)
        @images = Array(images).map { |img| normalize_image(img) }
      end

      def to_html
        return "" if @images.empty?

        html = %(<div class="#{variant_class(BASE_CLASS)}" data-editorial-block="asymmetric_gallery" data-variant="#{escape_html(@variant)}">)
        @images.each_with_index do |img, index|
          html += figure_html(img, index)
        end
        html += %(</div>)
        html
      end

      private

      def figure_html(img, index)
        id_attr = img[:id] ? %( data-image-id="#{escape_html(img[:id])}") : ""
        figure = %(<figure class="#{BASE_CLASS}__item #{BASE_CLASS}__item--#{index}">)
        figure += %(<img src="#{escape_html(img[:url])}" alt="#{escape_html(img[:alt])}"#{id_attr}>)
        figure += %(<figcaption class="#{BASE_CLASS}__caption">#{sanitize_inline(img[:caption])}</figcaption>) unless img[:caption].strip.empty?
        figure += %(</figure>)
        figure
      end

      def normalize_image(img)
        data = img.is_a?(Hash) ? img : {}
        payload = {
          url: (data[:url] || data["url"]).to_s,
          alt: (data[:alt] || data["alt"]).to_s,
          caption: (data[:caption] || data["caption"]).to_s
        }
        id = data[:id] || data["id"]
        payload[:id] = id if id
        payload
      end

      def validate
        validate_variant

        range = MIN_MAX_IMAGES[@variant]
        if range && !range.cover?(@images.size)
          @errors << "variant #{@variant} requires #{range.min}-#{range.max} images (got #{@images.size})"
        end

        @images.each_with_index do |img, i|
          @errors << "image #{i} url cannot be blank" if img[:url].strip.empty?
        end
      end

      def data_to_h
        { variant: @variant, images: @images }
      end
    end
  end
end
