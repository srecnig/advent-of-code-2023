# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-14/reflector_dish'

class ReflectorDishTest < Minitest::Test
  include ReflectorDish

  def test_initialization
    lines = [
      'O....#....',
      'O.OO#....#',
      '.....##...',
      'OO.#O....O'
    ]
    dish = Dish.new(lines)
    assert_equal [Ground.new('O'), Ground.new('O'), Ground.new('.'), Ground.new('O')], dish.columns[0]
    assert_equal [Ground.new('.'), Ground.new('O'), Ground.new('.'), Ground.new('.')], dish.columns[2]
    assert_equal [Ground.new('.'), Ground.new('#'), Ground.new('.'), Ground.new('O')], dish.columns[4]
    assert_equal [Ground.new('.'), Ground.new('.'), Ground.new('#'), Ground.new('.')], dish.columns[6]
  end

  def test_tilt_column
    lines = [
      'O....#....',
      'O.OO#....#',
      '.....##...',
      'OO.#O....O'
    ]
    dish = Dish.new(lines)
    result = [Ground.new('O'), Ground.new('O'), Ground.new('O'), Ground.new('.')]
    assert_equal result, dish.tilt_column(dish.columns[0])
    result = [Ground.new('O'), Ground.new('.'), Ground.new('.'), Ground.new('.')]
    assert_equal result, dish.tilt_column(dish.columns[1])
    result = [Ground.new('O'), Ground.new('.'), Ground.new('.'), Ground.new('.')]
    assert_equal result, dish.tilt_column(dish.columns[2])
    result = [Ground.new('O'), Ground.new('.'), Ground.new('.'), Ground.new('#')]
    assert_equal result, dish.tilt_column(dish.columns[3])
    result = [Ground.new('.'), Ground.new('#'), Ground.new('O'), Ground.new('.')]
    assert_equal result, dish.tilt_column(dish.columns[4])
  end

  def test_ground
    ground = Ground.new('#')
    assert_equal true, ground.cube_rock?
    assert_equal false, ground.round_rock?
    assert_equal false, ground.empty_space?
  end
end
