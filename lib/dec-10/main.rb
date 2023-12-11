# frozen_string_literal: true

require_relative 'pipe_maze'

def main1(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  pipe_map = PipeMaze::PipeMap.new(lines)
  pipe_map.follow_start!
  pipe_map.calculate_inside!
  pipe_map.print_inside
  p pipe_map.path.length / 2
  p pipe_map.inside_points.length
end

main1('input3.txt')
