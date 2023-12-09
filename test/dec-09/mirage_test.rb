# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-09/mirage'

class MirageTest < Minitest::Test
  include Mirage
  def test_history_initialization_works
    history = History.new('0 3 6 9 12 15')
    assert_equal [0, 3, 6, 9, 12, 15], history.values
  end

  def test_next_line_works
    history = History.new('0 3 6 9 12 15')
    assert_equal [3, 3, 3, 3, 3], history.next_row([0, 3, 6, 9, 12, 15])
    assert_equal [0, 0, 0, 0], history.next_row([3, 3, 3, 3, 3])
  end

  def test_expand_works
    history = History.new('0 3 6 9 12 15')
    expanded_history = [[0, 3, 6, 9, 12, 15], [3, 3, 3, 3, 3], [0, 0, 0, 0]]
    assert_equal expanded_history, history.expanded
  end

  def test_predict_works
    history = History.new('0 3 6 9 12 15')
    predicted_history = [[0, 3, 6, 9, 12, 15, 18], [3, 3, 3, 3, 3, 3], [0, 0, 0, 0, 0]]
    assert_equal predicted_history, history.predicted
    assert_equal 18, history.predicted[0][-1]
  end

  def test_redict_works
    history = History.new('10  13  16  21  30  45')
    redicted_history = [
      [5, 10, 13, 16, 21, 30, 45], [5, 3, 3, 5, 9, 15], [-2, 0, 2, 4, 6], [2, 2, 2, 2], [0, 0, 0]
    ]
    assert_equal redicted_history, history.redicted
    assert_equal 5, history.redicted[0][0]
  end
end
