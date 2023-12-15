# frozen_string_literal: true

module LensLibrary
  def self.hash(str)
    str.each_char.inject(0) do |current_value, character|
      current_value += character.ord
      current_value *= 17
      current_value % 256
    end
  end
end
