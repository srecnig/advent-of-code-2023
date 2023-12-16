# frozen_string_literal: true

require_relative 'lens_library'

def main1(filepath)
  single_line = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  result = single_line[0].split(',').inject(0) { |r, str| r + LensLibrary.hash(str) }
  p result
end

def main2(filepath)
  single_line = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  hash_map = LensLibrary::HashMap.new
  operations = single_line[0].split(',').map do |op_string|
    op = op_string[-1] == '-' ? :remove : :set
    if op == :remove
      key = op_string[..-2]
      value = nil
    else
      set_arr = op_string.split('=')
      key = set_arr[0]
      value = set_arr[1].to_i
    end
    [LensLibrary::Lens.new(key, value), op]
  end
  operations.each { |(lens, op)| hash_map.operate!(lens, op) }
  # ||   # .inject(0) { |_op| [] }
  result = operations.map { |(lens, _op)| lens.label }.uniq.inject(0) do |r, key|
    r + hash_map.focusing_power(key)
  end
  p result
end

main1('input.txt')
main2('input.txt')
