# frozen_string_literal: true

def digit?(char)
  !char.match(/[[:digit:]]/).nil?
end

def digitize(string)
  replacements = {
    'one' => '1e',
    'two' => '2o',
    'three' => '3e',
    'four' => '4',
    'five' => '5e',
    'six' => '6',
    'seven' => '7n',
    'eight' => '8t',
    'nine' => '9e'
  }
  old_string = string
  new_string = nil

  loop do
    new_string = old_string.sub(/(one|two|three|four|five|six|seven|eight|nine)/, replacements)
    break if new_string == old_string

    old_string = new_string
  end
  new_string
end

def extract_number(string, digitize: false)
  string = digitize(string) if digitize

  digits = string.each_char.filter { |char| digit?(char) }
  return if digits.empty?

  (digits.first + digits.last).to_i
end

def main1(filepath)
  result = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true).inject(0) do |memo, string|
    memo += extract_number(string)
    memo
  end
  p result
end

def main2(filepath)
  result = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true).inject(0) do |memo, string|
    memo += extract_number(string, digitize: true)
    memo
  end
  p result
end

main1('input.txt')
main2('input.txt')
