def digit?(char)
  !char.match(/[[:digit:]]/).nil?
end

def extract_number(string)
  digits = string.each_char.filter { |char| digit?(char) }
  unless digits.empty?
    (digits.first + digits.last).to_i
  end
end  

def digitize_string(string)
  replacements = {
    'one' => '1',
    'two' => '2',
    'three' => '3',
    'four' => '4',
    'five' => '5',
    'six' => '6',
    'seven' => '7',
    'eight' => '8',
    'nine' => '9',
  }
  string.gsub(/(one|two|three|four|five|six|seven|eight|nine)/, replacements)
end

def main1(filepath)
  result = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true).inject(0) do |memo, string|
    memo += extract_number(string)
    memo
  end
  p result
end

def main2(filepath)
  result = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true) .inject(0) do |memo, string|
    memo += extract_number(digitize_string(string))
    memo
  end
  p result
end


main1('input.txt')
main2('input.txt')