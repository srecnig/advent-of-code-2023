# frozen_string_literal: true

require_relative 'mirage'

def main1(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  result1 = lines.inject(0) do |sum, line|
    sum + Mirage::History.new(line).predicted[0][-1]
  end
  p result1
  result2 = lines.inject(0) do |sum, line|
    sum + Mirage::History.new(line).redicted[0][0]
  end
  p result2
end

main1('input.txt')
