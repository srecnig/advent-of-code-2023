# frozen_string_literal: true

module Fertilizer
  class RangedAlmanac
    attr_reader :seeds, :maps

    def initialize(almanac)
      parsed_almanac = almanac.lines.slice_before("\n").map { |l| l.map(&:strip).reject(&:empty?) }
      @seeds = parsed_almanac[0][0].split('seeds: ')[1].split.map(&:to_i).each_slice(2).map do |l|
        l[0]...(l[0] + l[1])
      end

      @maps = parsed_almanac[1..].map do |map_data|
        source, destination = map_data[0].split[0].split('-to-').map(&:to_sym)
        range_strings = map_data[1..]
        RangedAlmanacMap.new(source:, destination:, range_strings:)
      end
    end

    def lookup
      @seeds.map do |seed|
        # every seed is now a range
        @maps.inject(seed) { |lookup, map| map[lookup] }
      end
    end
  end

  class RangedAlamancRange
    attr_reader :source_range, :destination_range

    def initialize(source_range, destination_range)
      @source_range = source_range
      @destination_range = destination_range
    end

    def source_contains?(input_range)
      if @source_range.include?(input_range.begin) && @source_range.include?(input_range.end - 1)
        :completely
      elsif @source_range.end <= input_range.begin || @source_range.begin >= input_range.end
        :not_at_all
      else
        :partially
      end
    end

    def transform_input(input_range)
      position_in_range = input_range.begin - @source_range.begin
      destination_start = @destination_range.begin + position_in_range
      destination_start...destination_start + input_range.size
    end
  end

  class RangedAlmanacMap
    attr_reader :source, :destination, :ranges

    def initialize(source:, destination:, range_strings:)
      @source = source
      @destination = destination

      ranges_normalized = range_strings.map(&:split).map { |d, s, l| [d.to_i, s.to_i, l.to_i] }
      ranges_unsorted = ranges_normalized.map do |destination_start, source_start, length|
        raise "length == 0, this shouldn't happen." if length.zero?

        RangedAlamancRange.new(
          (source_start...(source_start + length)),
          (destination_start...(destination_start + length))
        )
      end
      @ranges = ranges_unsorted.sort_by { |r| r.source_range.begin }
      @lower_bound = @ranges.first.source_range.begin
      @upper_bound = @ranges.last.source_range.end
    end

    def [](input_range)
      if input_range.end <= @lower_bound || input_range.begin >= @upper_bound
        # if it's outside the ranges of this map we're done.
        input_range
      elsif @ranges.any? { |r| r.source_contains?(input_range) == :completely }
        # if it's completely contained in one range, we can just add the offset
        containing_range = @ranges.find { |r| r.source_contains?(input_range) == :completely }
        containing_range.transform_input(input_range)
        # destination_range = containing_range.destination_range
        # position_in_range = input_range.begin - containing_range.source_range.begin
        # destination_start = destination_range.begin + position_in_range
        # destination_start...destination_start + input_range.size
      else
        # if it's partially contained in one range, we need to split it up

        # first, get the ranges that contain the input range
        @ranges.reject { |r| r.source_contains?(input_range) == :not_at_all }

        raise 'Do we need this?'
      end
    end
  end

  class Almanac
    attr_reader :seeds, :maps

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

  AlamancRange = Struct.new(:range, :destination_start)

  class AlmanacMap
    attr_reader :source, :destination

    def initialize(source:, destination:, range_strings:)
      @source = source
      @destination = destination
      @input_ranges = []

      range_strings.map(&:split).map { |d, s, l| [d.to_i, s.to_i, l.to_i] }.each do |dest_start, src_start, length|
        raise "length == 0, this shouldn't happen." if length.zero?

        @input_ranges << AlamancRange.new((src_start...(src_start + length)), dest_start)
      end
    end

    def [](key)
      @input_ranges.each do |input_range|
        if input_range.range.include?(key)
          position_in_range = key - input_range.range.begin
          return input_range.destination_start + position_in_range
        end
      end
      key
    end
  end
end
