# frozen_string_literal: true

require_relative 'wait_for_it'

def main1(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  durations = lines[0].split('Time:')[1].strip.split.map(&:to_i)
  records = lines[1].split('Distance:')[1].strip.split.map(&:to_i)
  races = durations.zip(records).map { |(duration, record)| WaitForIt::Race.new(duration, record) }
  result = races.inject(1) do |error_margin, race|
    WaitForIt.calculate_strategies(race).select(&:winning?).length * error_margin
  end
  p result
end

def main2(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  duration = lines[0].split('Time:')[1].strip.split.join.to_i
  record = lines[1].split('Distance:')[1].strip.split.join.to_i

  race = WaitForIt::Race.new(duration, record)
  p WaitForIt.calculate_strategies(race).select(&:winning?).length
end

main1('input.txt')
main2('input.txt')
