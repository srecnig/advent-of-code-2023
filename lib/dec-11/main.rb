# frozen_string_literal: true

require_relative 'cosmic_expansion'

def main1(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  galaxy_map = CosmicExpansion::GalaxyMap.new(lines, 2)
  result = galaxy_map.galaxy_pairs.inject(0) do |memo, pair|
    memo + pair[0].distance(pair[1])
  end
  p result
end

def main2(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  galaxy_map = CosmicExpansion::GalaxyMap.new(lines, 1_000_000)
  result = galaxy_map.galaxy_pairs.inject(0) do |memo, pair|
    memo + pair[0].distance(pair[1])
  end
  p result
end

main1('input.txt')
main2('input.txt')
