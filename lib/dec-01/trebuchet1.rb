def digit?(char)
  !char.match(/[[:digit:]]/).nil?
end

def extract_number(string)
  digits = string.each_char.filter { |char| digit?(char) }
  unless digits.empty?
    (digits.first + digits.last).to_i
  end
end  

def main(filepath)
  result = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true).inject(0) do |memo, string|
    memo += extract_number(string)
    memo
  end
  p result
end

main('input.txt')
