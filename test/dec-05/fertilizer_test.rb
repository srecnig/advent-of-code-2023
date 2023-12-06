# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-05/fertilizer'

class FertilizerTest < Minitest::Test
  include Fertilizer

  def test_initialize_ranged_alamanc_works
    almanac_string = %(seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15)
    almanac = RangedAlmanac.new(almanac_string)
    assert_equal [(79...93), (55...68)], almanac.seeds
    assert_equal 2, almanac.maps.length
    assert_equal :seed, almanac.maps[0].source
    assert_equal :soil, almanac.maps[0].destination
    assert_equal :soil, almanac.maps[1].source
    assert_equal :fertilizer, almanac.maps[1].destination
    assert_equal 50, almanac.maps[0].ranges[0].source_range.begin
    assert_equal 98, almanac.maps[0].ranges[1].source_range.begin
    assert_equal 0, almanac.maps[1].ranges[0].source_range.begin
    assert_equal 15, almanac.maps[1].ranges[1].source_range.begin
    assert_equal 52, almanac.maps[1].ranges[2].source_range.begin
  end

  def test_initialize_ranged_alamanc_map_works
    almanac_map = RangedAlmanacMap.new(source: :seed, destination: :soil, range_strings: ['50 98 2', '52 50 48'])
    assert_equal 50, almanac_map.ranges[0].source_range.begin
    assert_equal 98, almanac_map.ranges[0].source_range.end
    assert_equal 52, almanac_map.ranges[0].destination_range.begin
    assert_equal 100, almanac_map.ranges[0].destination_range.end
    assert_equal 98, almanac_map.ranges[1].source_range.begin
    assert_equal 100, almanac_map.ranges[1].source_range.end
    assert_equal 50, almanac_map.ranges[1].destination_range.begin
    assert_equal 52, almanac_map.ranges[1].destination_range.end
  end

  def test_ranged_alamanc_lookup_works
    almanac_map = RangedAlmanacMap.new(source: :seed, destination: :soil, range_strings: ['50 98 2', '52 50 48'])
    # the input range is outside the range, so it doesn't change
    assert_equal [0...10], almanac_map[0...10]
    assert_equal [100...110], almanac_map[100...110]

    # the input range is completely in one range
    assert_equal [62...72], almanac_map[60...70]
    assert_equal [50...52], almanac_map[98...100]

    # the input range is partially in ranges, we need to split up
    # before transformation: [60...98, 98...100, 100...110] # 100...110last TBD
    assert_equal [62...100, 50...52], almanac_map[60...110]

    # the input range would need to be split up into multiple rages. unclear if this is needed.
    # assert_raises(RuntimeError) do
    #
    # end
  end

  # def source_contains?(input_range)
  #   if @source_range.include?(input_range.begin) && @source_range.include?(input_range.end - 1)
  #     :completely
  #   elsif @source_range.include?(input_range.begin) || @source_range.include?(input_range.end - 1)
  #     :partially
  #   elsif @source_range.begin >= input_range.begin && @source_range.end <= input_range.end
  #     :is_contained_in
  #   else
  #     :not_at_all
  #   end
  # end

  def test_ranged_alamanc_range
    range = RangedAlamancRange.new(50...100, 1000...1050)
    assert_equal :completely, range.source_contains?(50...60)
    assert_equal :completely, range.source_contains?(90...100)
    assert_equal :partially, range.source_contains?(40...51) # 50 is included
    assert_equal :partially, range.source_contains?(99...110) # 99 is included
    assert_equal :partially, range.source_contains?(40...120)
    assert_equal :partially, range.source_contains?(40...100)
    assert_equal :not_at_all, range.source_contains?(40...50)
    assert_equal :not_at_all, range.source_contains?(100...110)
  end

  def test_ranged_alamanc_range_transform_input
    range = RangedAlamancRange.new(50...100, 1030...1080)
    assert_equal 1030...1040, range.transform_input(50...60)
    assert_equal 1030...1080, range.transform_input(50...100)
    assert_raises(RuntimeError) do
      range.transform_input(50...200)
    end
  end

  def test_initialize_almanac_works
    almanac_string = %(seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15)
    almanac = Almanac.new(almanac_string)
    assert_equal [79, 14, 55, 13], almanac.seeds
    assert_equal 2, almanac.maps.length
    assert_equal :seed, almanac.maps[0].source
    assert_equal :soil, almanac.maps[0].destination
    assert_equal :soil, almanac.maps[1].source
    assert_equal :fertilizer, almanac.maps[1].destination

    assert_equal 49, almanac.maps[0][49]
    assert_equal 52, almanac.maps[0][50]
  end

  def test_lookup
    almanac_string = %(seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15)
    almanac = Almanac.new(almanac_string)
    assert_equal [81, 53, 57, 52], almanac.lookup
  end

  def test_initialize_map_works
    almanac_map = AlmanacMap.new(source: :seed, destination: :soil, range_strings: ['50 98 2', '52 50 48'])
    assert_equal 49, almanac_map[49]
    assert_equal 52, almanac_map[50]
    assert_equal 53, almanac_map[51]
    assert_equal 54, almanac_map[52]
    # ...
    assert_equal 98, almanac_map[96]
    assert_equal 99, almanac_map[97]
    assert_equal 50, almanac_map[98]
    assert_equal 51, almanac_map[99]
    assert_equal 100, almanac_map[100]
    # more
    assert_equal 81, almanac_map[79]
    assert_equal 14, almanac_map[14]
    assert_equal 57, almanac_map[55]
    assert_equal 13, almanac_map[13]
  end

  def test_length_0_raises_error
    assert_raises(RuntimeError) do
      AlmanacMap.new(source: :seed, destination: :soil, range_strings: ['50 98 2', '52 50 0'])
    end
  end
end
