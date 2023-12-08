# frozen_string_literal: true

require_relative 'wasteland'

def main1(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  node_map = Wasteland::NodeMap.new(lines[0], lines[2..])
  p node_map.traverse!
end

def main2(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  node_map = Wasteland::NodeMap.new(lines[0], lines[2..])
  p node_map.traverse_multiple!
end

# main1('input.txt')
main2('input.txt')
