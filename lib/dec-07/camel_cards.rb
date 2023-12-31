# frozen_string_literal: true

module CamelCards
  class Hand
    include Comparable

    attr_reader :cards, :hand

    def initialize(hand)
      @hand = hand
      @cards = hand.each_char.map { |rank| Card.new(rank) }
    end

    def hand_type
      tally = @cards.each.tally

      if tally.any? { |_card, count| count == 5 }
        :five_of_a_kind
      elsif tally.any? { |_card, count| count == 4 }
        :four_of_a_kind
      elsif tally.any? { |_card, count| count == 3 } && tally.any? { |_card, count| count == 2 }
        :full_house
      elsif tally.any? { |_card, count| count == 3 }
        :three_of_a_kind
      elsif tally.select { |_card, count| count == 2 }.length == 2
        :two_pair
      elsif tally.any? { |_card, count| count == 2 }
        :one_pair
      else
        :highcard
      end
    end

    def <=>(other)
      hand_type_rank = {
        five_of_a_kind: 6, four_of_a_kind: 5, full_house: 4, three_of_a_kind: 3, two_pair: 2,
        one_pair: 1, highcard: 0
      }
      if hand_type == other.hand_type
        tiebreaker_cards = @cards.zip(other.cards).find { |me, other| me.value != other.value }
        tiebreaker_cards[0].value <=> tiebreaker_cards[1].value
      else
        hand_type_rank[hand_type] <=> hand_type_rank[other.hand_type]
      end
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

  class InterestingHand < Hand
    # rubocop:disable Lint/MissingSuper
    def initialize(hand)
      @hand = hand
      @cards = hand.each_char.map { |rank| InterestingCard.new(rank) }
    end
    # rubocop:enable Lint/MissingSuper

    def hand_type
      hand_type_without_jokers = super()
      return hand_type_without_jokers if @cards.none?(&:joker?)

      joker_count = @cards.select(&:joker?).count
      jokerize_hand(hand_type_without_jokers, joker_count)
    end

    def jokerize_hand(hand_type, joker_count)
      case hand_type
      when :five_of_a_kind, :four_of_a_kind, :full_house
        :five_of_a_kind # JJJJJ or QQQQJ, JJJJK or 444JJ, JJJ44
      when :three_of_a_kind
        :four_of_a_kind # JJJ78, # 777JK
      when :two_pair
        if joker_count == 1
          :full_house # 33JQQ
        else
          :four_of_a_kind # 33JJQ
        end
      when :one_pair
        :three_of_a_kind # A3JQK
      when :highcard
        :one_pair
      end
    end
  end

  class InterestingCard < Card
    def self.get_value(rank)
      rank_mapping = {
        J: 1,
        '2': 2,
        '3': 3,
        '4': 4,
        '5': 5,
        '6': 6,
        '7': 7,
        '8': 8,
        '9': 9,
        T: 10,
        Q: 12,
        K: 13,
        A: 14
      }
      rank_mapping[rank]
    end

    def joker?
      @rank == 'J'
    end
  end
end
