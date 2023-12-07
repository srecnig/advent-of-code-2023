# frozen_string_literal: true

module CamelCards
  class Hand
    attr_reader :cards

    def initialize(hand)
      @cards = hand.each_char.map { |rank| Card.new(rank) }
    end

    def strength
      tally = @cards.each.tally

      if tally.any? { |_card, count| count == 5 }
        :five_of_a_kind
      elsif tally.any? { |_card, count| count == 4 }
        :four_of_a_kind
      elsif tally.any? { |_card, count| count == 3 } && tally.any? { |_card, count| count == 2 }
        :full_house
      else
        :something_else
      end

      # @cards.each.
      # 'AAAAK'.each_char.tally.any? {|rank, count| count == 4}
    end
  end

  class Card
    attr_reader :value, :rank

    def self.get_value(rank)
      rank_mapping = {
        '2': 2,
        '3': 3,
        '4': 4,
        '5': 5,
        '6': 6,
        '7': 7,
        '8': 8,
        '9': 9,
        T: 10,
        J: 11,
        Q: 12,
        K: 13,
        A: 14
      }
      rank_mapping[rank]
    end

    def initialize(rank)
      @rank = rank
      @value = self.class.get_value(rank.to_sym)
    end

    def ==(other)
      other.is_a?(Card) && @value == other.value
    end

    def eql?(other)
      self == other
    end

    def hash
      @value.hash
    end
  end
end
