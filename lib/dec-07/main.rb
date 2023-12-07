# frozen_string_literal: true

require_relative 'camel_cards'

def main1(filepath)
  bets = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true).map do |line|
    [CamelCards::Hand.new(line.split[0]), line.split[1].to_i]
  end
  result = bets.sort { |a, b| a[0] <=> b[0] }.map.with_index(1) { |b, i| [i, b[1]] }.inject(0) do |sum, bet|
    sum + (bet[0] * bet[1])
  end
  p result
end

main1('input.txt')
