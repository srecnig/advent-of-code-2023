# frozen_string_literal: true

require_relative 'lavaduct'

def main1(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  manual = Lavaduct::DiggingManual.new(lines)
  manual.dig!
  manual.print
  p manual.diggings
end

main1('input.txt')
