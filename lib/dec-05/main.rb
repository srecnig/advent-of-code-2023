# frozen_string_literal: true

require_relative 'fertilizer'

def main1(filepath)
  almanac_content = File.read(File.join(File.dirname(__FILE__), filepath))
  almanac = Fertilizer::Almanac.new(almanac_content)
  p almanac.lookup.min
end

def main2(filepath)
  almanac_content = File.read(File.join(File.dirname(__FILE__), filepath))
  almanac = Fertilizer::RangedAlmanac.new(almanac_content)
  p almanac.lookup.map(&:begin).min
end

main1('input.txt')
main2('input.txt')
