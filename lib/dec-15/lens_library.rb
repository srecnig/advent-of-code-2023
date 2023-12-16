# frozen_string_literal: true

module LensLibrary
  def self.hash(str)
    str.each_char.inject(0) do |current_value, character|
      current_value += character.ord
      current_value *= 17
      current_value % 256
    end
  end

  Box = Struct.new(:multiplier, :content)
  Lens = Struct.new(:label, :focal_length)

  class HashMap
    def initialize
      @boxes = {}
      256.times do |i|
        @boxes[i] = Box.new(i + 1, [])
      end
    end

    def [](key)
      @boxes[LensLibrary.hash(key)]
    end

    def operate!(lens, operation)
      box = @boxes[LensLibrary.hash(lens.label)]
      lens_locations = box.content.each.with_index.with_object([]) do |(l, i), locations|
        locations << i if l.label == lens.label
      end
      if operation == :remove
        lens_locations.reverse.each { |index| box.content.delete_at(index) }
      elsif lens_locations.empty?
        box.content << lens
      else
        lens_locations.each { |index| box.content[index] = lens }
      end
    end

    def focusing_power(key)
      box = @boxes[LensLibrary.hash(key)]
      box_multiplier = box.multiplier
      key_index = box.content.find_index { |l| l.label == key }
      slot_multiplier = key_index.nil? ? 0 : key_index + 1
      focal_length = key_index.nil? ? 0 : box.content[slot_multiplier - 1].focal_length

      box_multiplier * slot_multiplier * focal_length
    end
  end
end
