# frozen_string_literal: true

require "json"

module EditorjsRails
  class Document
    attr_reader :time, :version, :blocks, :errors

    def initialize(json)
      data = json.is_a?(String) ? JSON.parse(json) : json
      data = data.transform_keys(&:to_s)

      @time = data["time"]
      @version = data["version"]
      @errors = []
      @blocks = parse_blocks(data.fetch("blocks", []))
    end

    def valid?
      @errors = []
      @errors << "blocks cannot be empty" if @blocks.empty?
      @blocks.each_with_index do |block, idx|
        next if block.valid?

        block.errors.each do |error|
          @errors << "Block #{idx} (#{block.type}): #{error}"
        end
      end
      @errors.empty?
    end

    def to_html
      @blocks.map(&:to_html).compact.join("\n")
    end

    def to_h
      { time: @time, version: @version, blocks: @blocks.map(&:to_h) }
    end

    private

    def parse_blocks(blocks_json)
      blocks_json.filter_map do |block_data|
        block_data = block_data.transform_keys(&:to_s)
        type = block_data["type"]
        id = block_data["id"]
        data = (block_data["data"] || {}).transform_keys(&:to_s)

        BlockRegistry.build(type, id, data)
      end
    end
  end
end
