# frozen_string_literal: true

require_relative 'scratchcards'

def main1(filepath)
  result = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true).inject(0) do |memo, line|
    memo + Scratchcards::Card.new(line).points
  end
  p result
end

main1('input.txt')