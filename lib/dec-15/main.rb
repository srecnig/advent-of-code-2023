# frozen_string_literal: true

require_relative 'lens_library'

def main1(filepath)
  single_line = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  result = single_line[0].split(',').inject(0) { |r, str| r + LensLibrary.hash(str) }
  p result
end

def main2(filepath)
  something = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  p something
end

main1('input.txt')
# main2('input1.txt')
