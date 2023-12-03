# frozen_string_literal: true

module GearRatios
  Coordinate = Struct.new(:x, :y)

  class Schematic
    def initialize(rows)
      @column_count = rows[0].length
      @row_count = rows.length
      @points = Array.new(@row_count) { Array.new(@column_count) }
      rows.each_with_index do |row, y_index|
        row.each_char.with_index do |char_, x_index|
          @points[y_index][x_index] = Point.new(
            Coordinate.new(x_index, y_index), char: char_
          )
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
        puts row.map(&:logical_char).join
      end
    end
  end

  class Point
    attr_accessor :is_number, :is_symbol, :is_blank, :is_adjacent
    attr_reader :x, :y, :char, :logical_char

    def initialize(coordinate, char:)
      @x = coordinate.x
      @y = coordinate.y
      @char = char
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

    def neighbours(zero:, max:)
      coordinates = [
        Coordinate.new(@x, @y - 1),
        Coordinate.new(@x + 1, @y - 1),
        Coordinate.new(@x + 1, @y),
        Coordinate.new(@x + 1, @y + 1),
        Coordinate.new(@x, @y + 1),
        Coordinate.new(@x - 1, @y + 1),
        Coordinate.new(@x - 1, @y),
        Coordinate.new(@x - 1, @y - 1)
      ]
      coordinates.filter { |n| n.x >= zero.x && n.y >= zero.y && n.x <= max.x && n.y <= max.y }
    end
  end
end
