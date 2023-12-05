# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-05/fertilizer'

class FertilizerTest < Minitest::Test
  include Fertilizer

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
