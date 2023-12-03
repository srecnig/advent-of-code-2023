# frozen_string_literal: true

require_relative 'gear_ratios'

def main1(filename)
  schematic_data = File.readlines(File.join(File.dirname(__FILE__), filename), chomp: true)
  schematic = GearRatios::Schematic.new(schematic_data)
  schematic.draw
end

main1('input1.txt')