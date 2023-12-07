# frozen_string_literal: true

require_relative 'camel_cards'

def main1(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  p lines
end

main1('input1.txt')
