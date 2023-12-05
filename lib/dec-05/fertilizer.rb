# frozen_string_literal: true

module Fertilizer
  class Almanac
    attr_reader :seeds, :maps, :locations

    def initialize(almanac)
      parsed_almanac = almanac.lines.slice_before("\n").map { |l| l.map(&:strip).reject(&:empty?) }
      @seeds = parsed_almanac[0][0].split('seeds: ')[1].split.map(&:to_i)
      @maps = []

      parsed_almanac[1..].map do |map_data|
        source, destination = map_data[0].split[0].split('-to-').map(&:to_sym)
        range_strings = map_data[1..]
        @maps << AlmanacMap.new(source:, destination:, range_strings:)
      end
    end

    def lookup
      @seeds.map do |seed|
        @maps.inject(seed) { |lookup, map| map[lookup] }
      end
    end
  end

  class AlmanacMap
    attr_reader :source, :destination

    def initialize(source:, destination:, range_strings:)
      p "source: #{source}, destination: #{destination}, range_strings: #{range_strings}"

      @source = source
      @destination = destination
      @mapping = {}

      range_strings.map(&:split).map { |d, s, l| [d.to_i, s.to_i, l.to_i] }.each do |dest_start, src_start, length|
        raise "length == 0, this shouldn't happen." if length.zero?

        length.times do |i|
          @mapping[src_start + i] = dest_start + i
        end
      end
    end

    def [](key)
      @mapping.fetch(key, key)
    end
  end
end
