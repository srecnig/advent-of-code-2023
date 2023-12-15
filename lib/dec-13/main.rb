# frozen_string_literal: true

require_relative 'incidence'

def main1(filepath)
  all_lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  result = all_lines.slice_before('').inject(0) do |r, lines|
    ash_map = Incidence::AshMap.new(lines.reject(&:empty?))
    vertical = ash_map.find_vertical_mirrors.inject(0) { |m, mr| mr.begin + 1 + m }
    horizontal = ash_map.find_horizontal_mirrors.inject(0) { |m, mr| mr.begin + 1 + m }
    r + (100 * horizontal) + vertical
  end
  p result
end

main1('input.txt')
