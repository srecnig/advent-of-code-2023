# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-13/incidence'

class IncidenceTest < Minitest::Test
  include Incidence

  def test_ash_map_iterators_work
    lines = [
      '#.##..##.',
      '..#.##.#.',
      '##......#',
      '##......#',
      '..#.##.#.',
      '..##..##.',
      '#.#.##.#.'
    ]
    ash_map = AshMap.new(lines)
    assert_equal ['#', '#', '.', '.', '.', '.', '.', '.', '#'], ash_map.rows(2)
    assert_equal ['#', '#', '.', '.', '#', '#', '#'], ash_map.columns(2)
  end

  def test_can_find_horizontal_mirrors
    lines = [
      '#.##..##.',
      '..#.##.#.',
      '##......#',
      '##......#',
      '..#.##.#.',
      '..##..##.',
      '#.#.##.#.'
    ]
    ash_map = AshMap.new(lines)
    assert_equal [4..5], ash_map.find_vertical_mirrors
  end

  def test_can_find_vertical_mirrors
    lines = [
      '#...##..#',
      '#....#..#',
      '..##..###',
      '#####.##.',
      '#####.##.',
      '..##..###',
      '#....#..#'
    ]
    ash_map = AshMap.new(lines)
    assert_equal [3..4], ash_map.find_horizontal_mirrors
  end

  def test_can_find_the_stupid_error
    lines = [
      '.#.#.##...####...', # 0
      '.#.#.###...######', # 1
      '####..#.#........', # 2
      '####..#.#.....#..', # 3
      '.#.#.###...######',
      '.#.#.##...####...',
      '######.#......##.',
      '##.#...#.....#.#.',
      '#.#.#.#.#.#.#.#.#',
      '#..####.###...###',
      '..#.###.#.##.#..#', # 10
      '...####.#.#.#..##', # 11
      '...####.#.#.#..##'
    ]
    ash_map = AshMap.new(lines)
    assert_equal ['.', '#', '.', '#', '#', '.', '#', '.', '#', '#', '.', '.', '.'], ash_map.columns(14)
    assert_equal [11..12], ash_map.find_horizontal_mirrors
  end
end
