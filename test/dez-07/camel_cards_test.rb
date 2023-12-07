# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-07/camel_cards'

class CamelCardsTest < Minitest::Test
  include CamelCards

  def test_hand_initialization
    hand = Hand.new('AAAAK')
    assert_equal 5, hand.cards.length
    assert_equal 'A', hand.cards[0].rank
    assert_equal 14, hand.cards[0].value
    assert_equal 'K', hand.cards[-1].rank
    assert_equal 13, hand.cards[-1].value
  end

  def test_hand_strength
    assert_equal :five_of_a_kind, Hand.new('AAAAA').strength
    assert_equal :five_of_a_kind, Hand.new('22222').strength
    assert_equal :four_of_a_kind, Hand.new('AA2AA').strength
    assert_equal :four_of_a_kind, Hand.new('2A222').strength
    assert_equal :full_house, Hand.new('23332').strength
    assert_equal :full_house, Hand.new('AKAKK').strength
  end

  def test_card_initialization
    assert_equal 2, Card.new('2').value
    assert_equal 8, Card.new('8').value
    assert_equal 10, Card.new('T').value
    assert_equal 14, Card.new('A').value
  end
end
