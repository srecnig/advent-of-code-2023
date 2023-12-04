# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-04/scratchcards'

class ScratchardsTest < Minitest::Test
  include Scratchcards

  def test_scratchcards
    card1 = Card.new('Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53')
    assert_equal 8, card1.points
    card4 = Card.new('Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83')
    assert_equal 1, card4.points
    card6 = Card.new('Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11')
    assert_equal 0, card6.points
  end

  def test_deck
    # 1 exists, 4 matching numbers, adds 1 to card2, adds 1 to card3
    card1 = Card.new('Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53')
    # 2 exists, 1 matching number, ( adds 1 to card 3 ) x 2
    card2 = Card.new('Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83')
    # 4 exist, 0 matching numbers, adds nothing
    card3 = Card.new('Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11')

    deck = Deck.new([card1, card2, card3])
    assert_equal 1, deck.cards[1].card_count
    assert_equal 2, deck.cards[2].card_count
    assert_equal 4, deck.cards[3].card_count
    assert_equal 7, deck.card_count
  end
end
