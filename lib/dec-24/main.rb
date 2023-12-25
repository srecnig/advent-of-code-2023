# frozen_string_literal: true

require_relative 'odds'

def main1(filepath, min, max)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  hailstones = Odds::Hailstones.new(lines, min, max)
  p hailstones.count_collisions
end

def main2(filepath)
  something = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  p something
end

main1('input1.txt', 7, 27)
main1('input.txt', 200_000_000_000_000, 400_000_000_000_000)
# main2('input1.txt')
