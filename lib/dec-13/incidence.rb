# frozen_string_literal: true

module Incidence
  class AshMap
    def initialize(lines)
      @rows = lines.map { |l| l.each_char.to_a }
      @columns = (0..(lines[0].length)).each.map { |i| lines.map { |l| l[i] } }
    end

    def rows(index)
      @rows[index]
    end

    def columns(index)
      @columns[index]
    end

    def find_vertical_mirrors
      candidates = @rows.map { |row| find_mirrors(row) }
      candidates[1..].inject(candidates[0]) { |m, x| m & x }
    end

    def find_horizontal_mirrors
      candidates = @columns.map { |column| find_mirrors(column) }
      candidates[1..].inject(candidates[0]) { |m, x| m & x }
    end

    def find_mirrors(character_list)
      length = character_list.length
      mirrors = []
      character_list.each_cons(2).with_index do |(_a, _b), i|
        steps = [i + 1, length - i - 1].min
        steps.times do |step|
          break if character_list[i - step] != character_list[i + 1 + step]

          # once we reach i- step is at zero, or i+1 is at the last index, we're done.
          next unless (i - step).zero? || (i + 1 + step + 1 == length)

          mirrors << (i..i + 1)
          break
        end
      end
      mirrors
    end
  end
end
