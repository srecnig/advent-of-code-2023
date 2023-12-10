# frozen_string_literal: true

require_relative 'pipe_maze'

def main1(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  pipe_map = PipeMaze::PipeMap.new(lines)
  pipe_map.follow_start!
  p pipe_map.path.length / 2
end

def main2(filepath)
  something = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  p something
end

main1('input.txt')
# main2('input1.txt')
