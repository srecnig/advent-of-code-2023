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

  def test_hand_type
    assert_equal :five_of_a_kind, Hand.new('AAAAA').hand_type
    assert_equal :five_of_a_kind, Hand.new('22222').hand_type
    assert_equal :four_of_a_kind, Hand.new('AA2AA').hand_type
    assert_equal :four_of_a_kind, Hand.new('2A222').hand_type
    assert_equal :full_house, Hand.new('23332').hand_type
    assert_equal :full_house, Hand.new('AKAKK').hand_type
  end

  def test_can_compare_hands
    assert_equal true, Hand.new('AAAAA') > Hand.new('KKKK3')
    assert_equal true, Hand.new('KKKK3') > Hand.new('KKAAA')
    assert_equal true, Hand.new('KKAAA') > Hand.new('222TQ')
    assert_equal true, Hand.new('222TQ') > Hand.new('4A4A2')
    assert_equal true, Hand.new('4A4A2') > Hand.new('23452')
    assert_equal true, Hand.new('23452') > Hand.new('AQJT4')
    assert_equal true, Hand.new('53462') > Hand.new('4QJT3')
    # tie breaker
    assert_equal true, Hand.new('33332') > Hand.new('2AAAA')
    assert_equal true, Hand.new('77888') > Hand.new('77788')
  end

  def test_can_sort_hands
    # rubocop:disable Naming/VariableName
    h32T3K = Hand.new('32T3K')
    hT55J5 = Hand.new('T55J5')
    hKK677 = Hand.new('KK677')
    hKTJJT = Hand.new('KTJJT')
    hQQQJA = Hand.new('QQQJA')

    unsorted = [h32T3K, hT55J5, hKK677, hKTJJT, hQQQJA].shuffle
    assert_equal [hQQQJA, hT55J5, hKK677, hKTJJT, h32T3K], unsorted.sort.reverse
    # rubocop:enable Naming/VariableName
  end

  def test_card_initialization
    assert_equal 2, Card.new('2').value
    assert_equal 8, Card.new('8').value
    assert_equal 10, Card.new('T').value
    assert_equal 14, Card.new('A').value
  end
end
