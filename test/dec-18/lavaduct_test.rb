# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-18/lavaduct'

class LavaductTest < Minitest::Test
  include Lavaduct

  def test_initialize
    lines = [
      'R 6 (#70c710)',
      'D 5 (#0dc571)',
      'L 2 (#5713f0)',
      'D 2 (#d2c081)',
      'R 2 (#59c680)',
      'D 2 (#411b91)',
      'L 5 (#8ceee2)',
      'U 2 (#caa173)',
      'L 1 (#1b58a2)',
      'U 2 (#caa171)',
      'R 2 (#7807d2)',
      'U 3 (#a77fa3)',
      'L 2 (#015232)',
      'U 2 (#7a21e3)'
    ]
    manual = DiggingManual.new(lines)
    assert_equal Command.new(:east, 6, '#70c710'), manual.commands[0]
    assert_equal Command.new(:south, 5, '#0dc571'), manual.commands[1]
    assert_equal Command.new(:west, 2, '#5713f0'), manual.commands[2]
    assert_equal 7, manual.column_count
    assert_equal 10, manual.row_count
  end

  def test_dig!
    lines = [
      'R 6 (#70c710)',
      'D 5 (#0dc571)',
      'L 2 (#5713f0)',
      'D 2 (#d2c081)',
      'R 2 (#59c680)',
      'D 2 (#411b91)',
      'L 5 (#8ceee2)',
      'U 2 (#caa173)',
      'L 1 (#1b58a2)',
      'U 2 (#caa171)',
      'R 2 (#7807d2)',
      'U 3 (#a77fa3)',
      'L 2 (#015232)',
      'U 2 (#7a21e3)'
    ]
    manual = DiggingManual.new(lines)
    manual.dig!
    manual.print
    assert_equal 62, manual.diggings
  end
end
