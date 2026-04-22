# frozen_string_literal: true

module EditorjsRails
  module Blocks
    # Editorial hero block: large title paired with a feature image.
    # Three variants drive the layout:
    #   - title-above : title full-width on top, image full-width below
    #   - title-right : title left (60%) + image right (40%) in a split
    #   - title-overlap : image full-width with title overlaid on a gradient scrim
    class HeroSplit < Base
      BASE_CLASS = "editorjs-hero-split"

      variants %w[title-above title-right title-overlap], default: "title-above"

      attr_reader :title, :title_tag, :image_url, :image_alt, :image_caption, :image_credit, :image_id, :image_bordered, :image_background

      TITLE_TAGS = %w[h1 h2].freeze

      def initialize(id:, type:, title: "", title_tag: "h1", variant: nil, image: nil, **_rest)
        super(id: id, type: type, variant: variant)
        @title = title.to_s
        @title_tag = TITLE_TAGS.include?(title_tag.to_s) ? title_tag.to_s : "h1"
        image_data = image.is_a?(Hash) ? image : {}
        @image_url = (image_data[:url] || image_data["url"]).to_s
        @image_alt = (image_data[:alt] || image_data["alt"]).to_s
        @image_caption = (image_data[:caption] || image_data["caption"]).to_s
        @image_credit = (image_data[:credit] || image_data["credit"]).to_s
        @image_id = image_data[:id] || image_data["id"]
        @image_bordered = truthy?(image_data[:bordered] || image_data["bordered"])
        @image_background = truthy?(image_data[:background] || image_data["background"])
      end

      def to_html
        html = %(<section class="#{variant_class(BASE_CLASS)}" data-editorial-block="hero_split" data-variant="#{escape_html(@variant)}">)
        html += title_html
        html += image_html
        html += %(</section>)
        html
      end

      private

      def title_html
        return "" if @title.strip.empty?

        %(<#{@title_tag} class="#{BASE_CLASS}__title">#{sanitize_inline(@title)}</#{@title_tag}>)
      end

      def image_html
        return "" if @image_url.strip.empty?

        id_attr = @image_id ? %( data-image-id="#{escape_html(@image_id)}") : ""
        classes = ["#{BASE_CLASS}__figure"]
        classes << "editorjs-image--bordered" if @image_bordered
        classes << "editorjs-image--background" if @image_background
        figure = %(<figure class="#{classes.join(' ')}">)
        figure += %(<img src="#{escape_html(@image_url)}" alt="#{escape_html(@image_alt)}"#{id_attr}>)
        figure += %(<figcaption class="#{BASE_CLASS}__caption">#{sanitize_inline(@image_caption)}</figcaption>) unless @image_caption.strip.empty?
        figure += %(<figcaption class="#{BASE_CLASS}__credit">#{sanitize_inline(@image_credit)}</figcaption>) unless @image_credit.strip.empty?
        figure += %(</figure>)
        figure
      end

      def truthy?(value)
        value == true || value == "true" || value == 1 || value == "1"
      end

      def validate
        validate_variant
        @errors << "title cannot be blank" if @title.strip.empty?
        @errors << "image url cannot be blank" if @image_url.strip.empty?
      end

      def data_to_h
        image = {
          url: @image_url, alt: @image_alt,
          caption: @image_caption, credit: @image_credit,
          bordered: @image_bordered, background: @image_background
        }
        image[:id] = @image_id if @image_id
        {
          variant: @variant,
          title: @title,
          title_tag: @title_tag,
          image: image
        }
      end
    end
  end
end
