# frozen_string_literal: true

module GearRatios
  Coordinate = Struct.new(:x, :y)

  class Schematic
    attr_reader :part_numbers, :gear_ratios

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
      # part numbers
      collect_number_points!
      filter_number_points!
      convert_to_numbers!
      # gear ratios
      collect_gear_number_points!
      convert_to_gear_ratios!
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

    def collect_gear_number_points!
      @gear_number_points = []
      @points.each do |row|
        row.each do |point|
          next unless point.is_gear_symbol

          number_neighbours = point.neighbours(zero: @zero, max: @max).map do |coordinate|
            at(coordinate)
          end.filter(&:is_number)

          p point
          p number_neighbours.length

          @gear_number_points << number_neighbours if number_neighbours.length == 2
        end
      end
    end

    def convert_to_gear_ratios!
      @gear_ratios = []
      # find the @gear_number_points (single points) in the global list of @number_points (list of points forming
      # a number). luckily we already needed this list in part 1, so we can just re-use it, even though this is not
      # super nice
      p @gear_number_points

      @gear_number_points.each do |gear_number_point_pair|
        point1 = gear_number_point_pair[0]
        number_points_list1 = @number_points.find { |number_point_list| number_point_list.any? { |np| np == point1 } }
        gear1_value = number_points_list1.map(&:char).join.to_i

        point2 = gear_number_point_pair[1]
        number_points_list2 = @number_points.find { |number_point_list| number_point_list.any? { |np| np == point2 } }
        gear2_value = number_points_list2.map(&:char).join.to_i

        @gear_ratios << (gear1_value * gear2_value)
      end
    end

    def draw
      @points.each do |row|
        puts row.map(&:debug_char).join
      end
    end
  end

  class Point
    attr_accessor :is_number, :is_symbol, :is_gear_symbol, :is_blank, :is_adjacent
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
      @is_number = false
      @is_symbol = false
      @is_gear_symbol = false
      @is_blank = false
      @logical_char = ''

      if @char == '.'
        @is_blank = true
        @logical_char = '.'
      elsif @char.match(/\d/)
        @is_number = true
        @logical_char = 'N'
      else
        @is_symbol = true
        if @char == '*'
          @is_gear_symbol = true
          @logical_char = 'G'
        else
          @is_gear_symbol = false
          @logical_char = 'X'
        end
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
