# frozen_string_literal: true

require_relative 'scratchcards'

def main1(filepath)
  result = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true).inject(0) do |memo, line|
    memo + Scratchcards::Card.new(line).points
  end
  p result
end

def main2(filepath)
  cards = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true).map do |line|
    Scratchcards::Card.new(line)
  end
  deck = Scratchcards::Deck.new(cards)
  p deck.card_count
end

main1('input.txt')
main2('input.txt')
