require_relative './cube_conundrum'

def main(filepath)
  bag = CubeConundrum::Bag.new(red=12, green=13, blue=14)
  result = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true).inject(0) do |memo, string|
    games = CubeConundrum::Game.parse(string)
    all_valid = bag.all_valid?(games)
    memo = all_valid ? memo + games[0].id : memo 
  end
  p result
end

main('input.txt')