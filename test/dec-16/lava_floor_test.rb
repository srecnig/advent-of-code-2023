# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-16/lava_floor'

class LavaFloorTest < Minitest::Test
  include LavaFloor

  def test_contraption
    lines = [
      '.|...\....',
      '|.-.\.....',
      '.....|-...',
      '........|.',
      '..........'
    ]
    contraption = Contraption.new(lines)
    assert_equal Point.new(Coordinate.new(0, 1), '|'), contraption[Coordinate.new(0, 1)]
    assert_equal Point.new(Coordinate.new(6, 2), '-'), contraption[Coordinate.new(6, 2)]
    assert_equal Point.new(Coordinate.new(8, 3), '|'), contraption[Coordinate.new(8, 3)]
    assert_equal Point.new(Coordinate.new(5, 0), '\\'), contraption[Coordinate.new(5, 0)]

    assert_equal true, contraption.in_bounds?(Coordinate.new(0, 0))
    assert_equal true, contraption.in_bounds?(Coordinate.new(1, 1))
    assert_equal false, contraption.in_bounds?(Coordinate.new(0, -1))
    assert_equal false, contraption.in_bounds?(Coordinate.new(-1, 0))
    assert_equal true, contraption.in_bounds?(Coordinate.new(9, 4))
    assert_equal true, contraption.in_bounds?(Coordinate.new(8, 4))
    assert_equal true, contraption.in_bounds?(Coordinate.new(9, 3))
    assert_equal false, contraption.in_bounds?(Coordinate.new(10, 4))
    assert_equal false, contraption.in_bounds?(Coordinate.new(9, 5))
  end

  def test_pass_through
    point = Point.new(Coordinate.new(5, 5), '.')
    assert_equal [Coordinate.new(5, 6)], point.pass_through(:north)
    assert_equal [Coordinate.new(4, 5)], point.pass_through(:east)
    assert_equal [Coordinate.new(5, 4)], point.pass_through(:south)
    assert_equal [Coordinate.new(6, 5)], point.pass_through(:west)

    point = Point.new(Coordinate.new(5, 5), '/')
    assert_equal [Coordinate.new(4, 5)], point.pass_through(:north)
    assert_equal [Coordinate.new(5, 6)], point.pass_through(:east)
    assert_equal [Coordinate.new(6, 5)], point.pass_through(:south)
    assert_equal [Coordinate.new(5, 4)], point.pass_through(:west)

    point = Point.new(Coordinate.new(5, 5), '|')
    assert_equal [Coordinate.new(5, 6)], point.pass_through(:north)
    assert_equal [Coordinate.new(5, 4), Coordinate.new(5, 6)], point.pass_through(:east)
    assert_equal [Coordinate.new(5, 4)], point.pass_through(:south)
    assert_equal [Coordinate.new(5, 4), Coordinate.new(5, 6)], point.pass_through(:west)
  end

  def test_splitter
    point = Point.new(Coordinate.new(5, 5), '|')
    assert_equal true, point.splitter?
    assert_equal [:north], point.split(:south)
    assert_equal [:south], point.split(:north)
    assert_equal %i[north south], point.split(:east)
    assert_equal %i[north south], point.split(:west)

    point = Point.new(Coordinate.new(5, 5), '-')
    assert_equal true, point.splitter?
    assert_equal [:west], point.split(:east)
    assert_equal [:east], point.split(:west)
    assert_equal %i[east west], point.split(:north)
    assert_equal %i[east west], point.split(:south)
  end

  def test_mirror
    point = Point.new(Coordinate.new(5, 5), '\\')
    assert_equal true, point.mirror?
    assert_equal [:east], point.reflect(:north)
    assert_equal [:north], point.reflect(:east)
    assert_equal [:west], point.reflect(:south)
    assert_equal [:south], point.reflect(:west)

    point = Point.new(Coordinate.new(5, 5), '/')
    assert_equal true, point.mirror?
    assert_equal [:west], point.reflect(:north)
    assert_equal [:south], point.reflect(:east)
    assert_equal [:east], point.reflect(:south)
    assert_equal [:north], point.reflect(:west)
  end
end
