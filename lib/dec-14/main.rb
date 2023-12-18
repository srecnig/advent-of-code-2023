# frozen_string_literal: true

require_relative 'reflector_dish'

def main1(filepath)
  lines = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  dish = ReflectorDish::Dish.new(lines)
  dish.tilt_north!
  p dish.total_load
end

def main2(filepath)
  something = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  p something
end

main1('input.txt')
# main2('input1.txt')
