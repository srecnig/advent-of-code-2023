# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-06/wait_for_it'

class WaitForItTest < Minitest::Test
  include WaitForIt

  def test_can_calculate_strategies
    race = Race.new(duration: 7, record: 9)
    strategies = WaitForIt.calculate_strategies(race)
    assert_equal 8, strategies.length
    assert_equal 4, strategies.select(&:winning?).length
    assert_equal 0, strategies[0].holding_duration
    assert_equal 0, strategies[0].distance
    assert_equal 1, strategies[1].holding_duration
    assert_equal 6, strategies[1].distance
    assert_equal 2, strategies[2].holding_duration
    assert_equal 10, strategies[2].distance
    assert_equal 3, strategies[3].holding_duration
    assert_equal 12, strategies[3].distance
    assert_equal 4, strategies[4].holding_duration
    assert_equal 12, strategies[4].distance
    assert_equal 5, strategies[5].holding_duration
    assert_equal 10, strategies[5].distance
    assert_equal 6, strategies[6].holding_duration
    assert_equal 6, strategies[6].distance
    assert_equal 7, strategies[7].holding_duration
    assert_equal 0, strategies[7].distance
  end
end
