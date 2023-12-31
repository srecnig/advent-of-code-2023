# frozen_string_literal: true

require_relative 'lava_floor'

def main1(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  contraption = LavaFloor::Contraption.new(lines)
  contraption.send_beam!(LavaFloor::Beam.new(LavaFloor::Coordinate.new(0, 0), :west))
  p contraption.beams.map(&:coordinate).uniq.length
end

main1('input.txt')
