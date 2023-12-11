# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-11/cosmic_expansion'

class CosmicExpansionTest < Minitest::Test
  include CosmicExpansion

  def test_expansion
    lines = [
      #  |     |
      '...#......',
      '.......#..',
      '#.........',
      '..........', # - 3
      '......#...',
      '.#........',
      '.........#',
      '..........', # - 7
      '.......#..',
      '#...#.....'
    ]
    galaxy_map = GalaxyMap.new(lines, 2)
    assert_equal [0, 0, 1, 4, 5, 8, 9, 9, 12], galaxy_map.galaxy_points.map { |p| p.coordinate.x }.sort
    assert_equal [0, 1, 2, 5, 6, 7, 10, 11, 11], galaxy_map.galaxy_points.map { |p| p.coordinate.y }.sort
  end

  def galaxy_pairs_works
    lines = [
      #  |     |
      '...#......',
      '.......#..',
      '#.........',
      '..........', # - 3
      '......#...',
      '.#........',
      '.........#',
      '..........', # - 7
      '.......#..',
      '#...#.....'
    ]
    galaxy_map = GalaxyMap.new(lines, 2)
    assert_equal 36, galaxy_map.galaxy_pairs.length
    p galaxy_map.galaxy_points
  end

  def test_point
    point1 = Point.new(Coordinate.new(0, 0), '.')
    assert_equal true, point1.empty_space?

    point2 = Point.new(Coordinate.new(1, 1), '#')
    assert_equal true, point2.galaxy?
  end

  def test_point_difference
    point = Point.new(Coordinate.new(0, 0), '#')
    assert_equal 6, point.distance(Point.new(Coordinate.new(3, 3), '#'))
    assert_equal 6, point.distance(Point.new(Coordinate.new(-3, 3), '#'))
    assert_equal 6, point.distance(Point.new(Coordinate.new(3, -3), '#'))
    assert_equal 6, point.distance(Point.new(Coordinate.new(-3, -3), '#'))
  end
end
