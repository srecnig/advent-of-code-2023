# frozen_string_literal: true

require_relative './cube_conundrum'

def main1(filepath)
  bag = CubeConundrum::Bag.new(red: 12, green: 13, blue: 14)
  result = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true).inject(0) do |memo, string|
    games = CubeConundrum::Game.parse(string)
    all_valid = bag.all_valid?(games)
    all_valid ? memo + games[0].id : memo
  end
  p result
end

def main2(filepath)
  result = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true).inject(0) do |memo, string|
    games = CubeConundrum::Game.parse(string)
    minimum_bag = CubeConundrum::Bag.minimum_bag(games)
    memo + minimum_bag.power
  end
  p result
end

main1('input.txt')
main2('input.txt')
