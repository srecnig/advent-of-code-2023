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
    galaxy = Galaxy.new(lines)
    assert_equal 12, galaxy.row_count
    assert_equal 13, galaxy.column_count
    # these vertical lines were added
    assert_equal true, galaxy.points[3].all?(&:empty_space?)
    assert_equal true, galaxy.points[4].all?(&:empty_space?)
    assert_equal true, galaxy.points[8].all?(&:empty_space?)
    assert_equal true, galaxy.points[9].all?(&:empty_space?)
    # columns have been added, which made the galaxies move
    assert_equal true, galaxy[Coordinate.new(12, 7)].galaxy?

    p 'aaaah'
    galaxy.points.each do |row|
      p(row.map { |p| "(#{p.coordinate.x}, #{p.coordinate.y})" }.join(' '))
    end
    p 'bbbbh'
    galaxy.points.each do |row|
      p(row.map(&:char).join(' '))
    end
  end

  def test_point
    point1 = Point.new(Coordinate.new(0, 0), '.')
    assert_equal true, point1.empty_space?

    point2 = Point.new(Coordinate.new(1, 1), '#')
    assert_equal true, point2.galaxy?
  end
end
