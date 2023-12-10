# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-10/pipe_maze'

class PipeMazeTest < Minitest::Test
  include PipeMaze

  def test_pipe_map
    lines = [
      '.....',
      '.F-7.',
      '.|.|.',
      '.L-J.',
      '.....'
    ]
    pipe_map = PipeMap.new(lines)
    assert_equal 'F', pipe_map[Coordinate.new(1, 1)].symbol
    assert_equal 'J', pipe_map[Coordinate.new(3, 3)].symbol
    assert_equal '.', pipe_map[Coordinate.new(4, 4)].symbol
  end

  def test_pipe_map_detects_start
    lines = [
      '-L|F7',
      '7S-7|',
      'L|7||',
      '-L-J|',
      'L|-JF'
    ]
    pipe_map = PipeMap.new(lines)
    assert_equal Coordinate.new(1, 1), pipe_map.start.coordinate
  end

  def test_point_symbol
    pipe = Point.new('|', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, pipe.blank?
    assert_equal false, pipe.start?
    assert_equal [Coordinate.new(5, 4), Coordinate.new(5, 6)], pipe.connects_to

    pipe = Point.new('-', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, pipe.blank?
    assert_equal false, pipe.start?
    assert_equal [Coordinate.new(6, 5), Coordinate.new(4, 5)], pipe.connects_to

    pipe = Point.new('L', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, pipe.blank?
    assert_equal false, pipe.start?
    assert_equal [Coordinate.new(5, 4), Coordinate.new(6, 5)], pipe.connects_to

    pipe = Point.new('J', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, pipe.blank?
    assert_equal false, pipe.start?
    assert_equal [Coordinate.new(5, 4), Coordinate.new(4, 5)], pipe.connects_to

    pipe = Point.new('7', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, pipe.blank?
    assert_equal false, pipe.start?
    assert_equal [Coordinate.new(5, 6), Coordinate.new(4, 5)], pipe.connects_to

    pipe = Point.new('F', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, pipe.blank?
    assert_equal false, pipe.start?
    assert_equal [Coordinate.new(6, 5), Coordinate.new(5, 6)], pipe.connects_to

    blank = Point.new('.', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal true, blank.blank?
    assert_equal false, blank.start?
    assert_equal [], blank.connects_to

    start = Point.new('S', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, start.blank?
    assert_equal true, start.start?
    assert_equal [], start.connects_to
  end

  def test_point_handles_edges
    point = Point.new('|', Coordinate.new(0, 0), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal [Coordinate.new(0, 1)], point.connects_to
    point = Point.new('J', Coordinate.new(0, 0), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal [], point.connects_to
    point = Point.new('-', Coordinate.new(10, 10), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal [Coordinate.new(9, 10)], point.connects_to
    point = Point.new('F', Coordinate.new(10, 10), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal [], point.connects_to
  end
end
