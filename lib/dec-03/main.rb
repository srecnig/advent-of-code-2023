# frozen_string_literal: true

require_relative 'gear_ratios'

def main1(filename)
  schematic_data = File.readlines(File.join(File.dirname(__FILE__), filename), chomp: true)
  schematic = GearRatios::Schematic.new(schematic_data)
  schematic.draw
  p schematic.part_numbers.inject(&:+)
  p schematic.gear_ratios #.inject(&:+)
end

main1('input1.txt')
