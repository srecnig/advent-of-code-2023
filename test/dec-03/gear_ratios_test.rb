# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-03/gear_ratios'

class GearRatiosTest < Minitest::Test
  include GearRatios

  def test_initalization
    schematic = Schematic.new(
      [
        '...4',
        '12.$',
        'b..$',
        '...5',
        '1@..'
      ]
    )
    assert_equal '.', schematic.at(0, 0).char
    assert_equal '4', schematic.at(3, 0).char
    assert_equal '1', schematic.at(0, 4).char
    assert_equal '.', schematic.at(3, 4).char
  end

  def test_apply_logic
    number_point = Point.new(Coordinate.new(0, 0), char: '5')
    number_point.apply_logic!
    assert_equal true, number_point.is_number
    assert_equal false, number_point.is_symbol
    assert_equal false, number_point.is_blank
    assert_equal 'N', number_point.logical_char

    blank_point = Point.new(Coordinate.new(0, 0), char: '.')
    blank_point.apply_logic!
    assert_equal false, blank_point.is_number
    assert_equal false, blank_point.is_symbol
    assert_equal true, blank_point.is_blank
    assert_equal '.', blank_point.logical_char

    symbol_point = Point.new(Coordinate.new(0, 0), char: '$')
    symbol_point.apply_logic!
    assert_equal false, symbol_point.is_number
    assert_equal true, symbol_point.is_symbol
    assert_equal false, symbol_point.is_blank
    assert_equal 'X', symbol_point.logical_char
  end

  def test_neighbours
    zero = Coordinate.new(0, 0)
    max = Coordinate.new(2, 2)
    p = Point.new(Coordinate.new(0, 0), char: '.')
    neighbours = p.neighbours(zero:, max:)
    assert_equal true, neighbours.any?(Coordinate.new(1, 0))
    assert_equal true, neighbours.any?(Coordinate.new(1, 1))
    assert_equal true, neighbours.any?(Coordinate.new(0, 1))
    assert_equal 3, neighbours.length

    p = Point.new(Coordinate.new(2, 2), char: '.')
    neighbours = p.neighbours(zero:, max:)
    assert_equal true, neighbours.any?(Coordinate.new(1, 2))
    assert_equal true, neighbours.any?(Coordinate.new(1, 1))
    assert_equal true, neighbours.any?(Coordinate.new(2, 1))
    assert_equal 3, neighbours.length

    p = Point.new(Coordinate.new(1, 1), char: '.')
    neighbours = p.neighbours(zero:, max:)
    assert_equal true, neighbours.any?(Coordinate.new(1, 0))
    assert_equal true, neighbours.any?(Coordinate.new(2, 0))
    assert_equal true, neighbours.any?(Coordinate.new(2, 1))
    assert_equal true, neighbours.any?(Coordinate.new(2, 2))
    assert_equal true, neighbours.any?(Coordinate.new(1, 2))
    assert_equal true, neighbours.any?(Coordinate.new(0, 2))
    assert_equal true, neighbours.any?(Coordinate.new(0, 1))
    assert_equal true, neighbours.any?(Coordinate.new(0, 0))
    assert_equal 8, neighbours.length

    p = Point.new(Coordinate.new(0, 1), char: '.')
    neighbours = p.neighbours(zero:, max:)
    assert_equal true, neighbours.any?(Coordinate.new(0, 0))
    assert_equal true, neighbours.any?(Coordinate.new(1, 0))
    assert_equal true, neighbours.any?(Coordinate.new(1, 1))
    assert_equal true, neighbours.any?(Coordinate.new(1, 2))
    assert_equal true, neighbours.any?(Coordinate.new(0, 2))
    assert_equal 5, neighbours.length
  end
end
