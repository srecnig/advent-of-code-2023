# frozen_string_literal: true

module Scratchcards
  class Card
    attr_reader :points

    def initialize(line)
      mine = line.split('|')[0].strip.split(':')[1].strip.split.map(&:to_i)
      winning = line.split('|')[1].strip.split.map(&:to_i)
      matching_count = mine.map { |n| winning.include?(n) }.count(true)
      @points = @points = matching_count.zero? ? 0 : 2**(matching_count - 1)
    end
  end
end
