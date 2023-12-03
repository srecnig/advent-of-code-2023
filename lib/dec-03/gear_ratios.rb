# frozen_string_literal: true

module GearRatios
  Coordinate = Struct.new(:x, :y)

  class Schematic
    attr_reader :part_numbers

    def initialize(rows)
      column_count = rows[0].length
      row_count = rows.length
      @zero = Coordinate.new(0, 0)
      @max = Coordinate.new(column_count - 1, row_count - 1)
      @points = Array.new(row_count) { Array.new(column_count) }
      rows.each_with_index do |row, y_index|
        row.each_char.with_index do |char_, x_index|
          @points[y_index][x_index] = Point.new(
            Coordinate.new(x_index, y_index), char: char_
          )
        end
      end
      build_logical_map!
      build_adjacents!
      collect_number_points!
      filter_number_points!
      convert_to_numbers!
    end

    def at(coordinate)
      @points[coordinate.y][coordinate.x]
    end

    def build_logical_map!
      @points.each do |row|
        row.each(&:apply_logic!)
      end
    end

    def build_adjacents!
      @points.each do |row|
        row.each do |point|
          next unless point.is_number

          is_adjacent = point.neighbours(zero: @zero, max: @max).any? do |coordinate|
            at(coordinate).is_symbol
          end
          point.is_adjacent = is_adjacent
        end
      end
    end

    def collect_number_points!
      @number_points = []
      @points.each do |row|
        new_number_points = []
        row.each do |point|
          if point.is_number
            # create new_number_points or add to existing
            if new_number_points.empty?
              new_number_points = [point]
            else
              new_number_points << point
            end
          else
            # skip if no current new_number_points
            next if new_number_points.empty?

            # or close existing one
            @number_points << new_number_points
            new_number_points = []
          end
        end
        unless new_number_points.empty?
          # there's still an open new_number_points, close it.
          @number_points << new_number_points
        end
      end
    end

    def filter_number_points!
      @number_points = @number_points.filter do |number_point_list|
        number_point_list.any?(&:is_adjacent)
      end
    end

    def convert_to_numbers!
      @part_numbers = []
      @number_points.each do |number_point_list|
        number = number_point_list.map(&:char).join.to_i
        @part_numbers << number
      end
    end

    def draw
      @points.each do |row|
        puts row.map(&:debug_char).join
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

    def debug_char
      return 'A' if @is_adjacent

      @logical_char
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
