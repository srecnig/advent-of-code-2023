# frozen_string_literal: true

module Scratchcards
  class Card
    attr_reader :points, :matching

    def initialize(line)
      mine = line.split('|')[0].strip.split(':')[1].strip.split.map(&:to_i)
      winning = line.split('|')[1].strip.split.map(&:to_i)
      @matching = mine.map { |n| winning.include?(n) }.count(true)
      @points = @matching.zero? ? 0 : 2**(@matching - 1)
    end
  end

  DeckCard = Struct.new(:card, :card_count)

  class Deck
    attr_reader :cards

    def initialize(cards)
      @cards = {}
      cards.each_with_index do |card, index|
        @cards[index + 1] = DeckCard.new(card, 1)
      end
      multiply!
    end

    def multiply!
      @cards.each do |card_number, deck_card|
        next unless deck_card.card.matching.positive?

        deck_card.card_count.times do
          (card_number + 1..card_number + deck_card.card.matching).each do |add_card_index|
            @cards[add_card_index].card_count = @cards[add_card_index].card_count + 1 if @cards[add_card_index]
          end
        end
      end
    end

    def card_count
      @cards.inject(0) do |memo, (_, deck_card)|
        memo + deck_card.card_count
      end
    end
  end
end
