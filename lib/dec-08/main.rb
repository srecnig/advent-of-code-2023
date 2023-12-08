# frozen_string_literal: true

require_relative 'wasteland'

def main1(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  node_map = Wasteland::NodeMap.new(lines[0], lines[2..])
  p node_map.traverse!
end

def main2(filepath)
  something = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  p something
end

main1('input1.txt')
main1('input2.txt')
main1('input.txt')
# main2('input1.txt')
