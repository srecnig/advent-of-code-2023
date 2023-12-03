# frozen_string_literal: true

module GearRatios
  class Schematic
    def initialize(rows)
      @column_count = rows[0].length
      @row_count = rows.length
      @points = Array.new(@row_count) { Array.new(@column_count) }
      rows.each_with_index do |row, y_index|
        row.each_char.with_index do |char, x_index|
          @points[y_index][x_index] = Point.new(x: x_index, y: y_index, char:)
        end
      end
      build_logical_map!
    end

    def at(x, y)
      @points[y][x]
    end

    def build_logical_map!
      @points.each do |row|
        row.each(&:apply_logic!)
      end
    end

    def draw
      @points.each do |row|
        p row.map(&:logical_char).join
      end
    end
  end

  class Point
    attr_accessor :is_number, :is_symbol, :is_blank, :is_adjacent
    attr_reader :x, :y, :char, :logical_char

    def initialize(x:, y:, char:)
      @x = x
      @y = y
      @char = char
      # @logical_char = char
    end

    def apply_logic!
      if @char == '.'
        @is_number = false
        @is_symbol = false
        @is_blank = true
        @logical_char = '.'
      elsif @char.match(/\d/)
        @is_number = true
        @is_symbol = false
        @is_blank = false
        @logical_char = 'N'
      else
        @is_number = false
        @is_symbol = true
        @is_blank = false
        @logical_char = 'X'
      end
    end
  end
end
