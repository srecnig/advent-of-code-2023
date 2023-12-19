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
    assert_equal 'F', pipe_map[Coordinate.new(1, 1)].char
    assert_equal 'J', pipe_map[Coordinate.new(3, 3)].char
    assert_equal '.', pipe_map[Coordinate.new(4, 4)].char
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

  def test_can_follow_start
    lines = [
      '-L|F7',
      '7S-7|',
      'L|7||',
      '-L-J|',
      'L|-JF'
    ]
    pipe_map = PipeMap.new(lines)
    pipe_map.follow_start!
    assert_equal 'F', pipe_map.start.logical_char
    assert_equal ['-', '7', '|', 'J', '-', 'L', '|', 'S'], pipe_map.path.map(&:char)
    assert_equal true, pipe_map[Coordinate.new(3, 1)].in_path
    assert_equal true, pipe_map[Coordinate.new(2, 1)].in_path
    assert_equal false, pipe_map[Coordinate.new(0, 1)].in_path
    assert_equal false, pipe_map[Coordinate.new(0, 2)].in_path
    assert_equal false, pipe_map[Coordinate.new(2, 2)].in_path

    lines = [
      '..F7.',
      '.FJ|.',
      'SJ.L7',
      '|F--J',
      'LJ...'
    ]
    pipe_map = PipeMap.new(lines)
    pipe_map.follow_start!
    steps = ['J', 'F', 'J', 'F', '7', '|', 'L', '7', 'J', '-', '-', 'F', 'J', 'L', '|', 'S']
    assert_equal 'F', pipe_map.start.logical_char
    assert_equal steps, pipe_map.path.map(&:char)
  end

  def test_can_count_inside_points
    lines = [
      '..........',
      '.S------7.',
      '.|F----7|.',
      '.||....||.',
      '.||....||.',
      '.|L-7F-J|.',
      '.|..||..|.',
      '.L--JL--J.',
      '..........'
    ]
    pipe_map = PipeMap.new(lines)
    pipe_map.follow_start!
    pipe_map.calculate_inside!
    assert_equal true, pipe_map.inside_points.map(&:coordinate).include?(Coordinate.new(2, 6))
    assert_equal true, pipe_map.inside_points.map(&:coordinate).include?(Coordinate.new(3, 6))
    assert_equal true, pipe_map.inside_points.map(&:coordinate).include?(Coordinate.new(6, 6))
    assert_equal true, pipe_map.inside_points.map(&:coordinate).include?(Coordinate.new(7, 6))
    assert_equal 4, pipe_map.inside_points.length
  end

  def test_point_char
    pipe = Point.new('|', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, pipe.start?
    assert_equal [Coordinate.new(5, 4), Coordinate.new(5, 6)], pipe.connects_to

    pipe = Point.new('-', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, pipe.start?
    assert_equal [Coordinate.new(6, 5), Coordinate.new(4, 5)], pipe.connects_to

    pipe = Point.new('L', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, pipe.start?
    assert_equal [Coordinate.new(5, 4), Coordinate.new(6, 5)], pipe.connects_to

    pipe = Point.new('J', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, pipe.start?
    assert_equal [Coordinate.new(5, 4), Coordinate.new(4, 5)], pipe.connects_to

    pipe = Point.new('7', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, pipe.start?
    assert_equal [Coordinate.new(5, 6), Coordinate.new(4, 5)], pipe.connects_to

    pipe = Point.new('F', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, pipe.start?
    assert_equal [Coordinate.new(6, 5), Coordinate.new(5, 6)], pipe.connects_to

    blank = Point.new('.', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal false, blank.start?
    assert_equal [], blank.connects_to

    # S can potentially connect to everything
    start = Point.new('S', Coordinate.new(5, 5), [Coordinate.new(0, 0), Coordinate.new(10, 10)])
    assert_equal true, start.start?
    assert_equal [
      Coordinate.new(5, 4), Coordinate.new(6, 5), Coordinate.new(5, 6), Coordinate.new(4, 5)
    ], start.connects_to
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
