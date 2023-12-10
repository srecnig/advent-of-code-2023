# frozen_string_literal: true

module PipeMaze
  Coordinate = Struct.new(:x, :y)

  class PipeMap
    attr_reader :start

    def initialize(lines)
      # read and create all the lines
      column_count = lines[0].length
      row_count = lines.length
      @zero = Coordinate.new(0, 0)
      @max = Coordinate.new(column_count - 1, row_count - 1)
      max_coordinates = [@zero, @max]

      @points = Array.new(row_count) { Array.new(column_count) }
      lines.each_with_index do |line, y_index|
        line.each_char.with_index do |char, x_index|
          new_point = Point.new(
            char, Coordinate.new(x_index, y_index), max_coordinates
          )
          @points[y_index][x_index] = new_point
          @start = new_point if new_point.start?
        end
      end
    end

    def [](coordinate)
      @points[coordinate.y][coordinate.x]
    end
  end

  class Point
    attr_reader :symbol, :coordinate

    def initialize(symbol, coordinate, max_coordinates)
      @symbol = symbol
      @coordinate = coordinate
      @zero = max_coordinates[0]
      @max = max_coordinates[1]
    end

    def north
      Coordinate.new(@coordinate.x, @coordinate.y - 1)
    end

    def east
      Coordinate.new(@coordinate.x + 1, @coordinate.y)
    end

    def south
      Coordinate.new(@coordinate.x, @coordinate.y + 1)
    end

    def west
      Coordinate.new(@coordinate.x - 1, @coordinate.y)
    end

    def connects_to
      connecting = []
      case @symbol
      when '|'
        connecting = [north, south]
      when '-'
        connecting = [east, west]
      when 'L'
        connecting = [north, east]
      when 'J'
        connecting = [north, west]
      when '7'
        connecting = [south, west]
      when 'F'
        connecting = [east, south]
      when '.', 'S'
        []
      end
      connecting.filter { |n| n.x >= @zero.x && n.y >= @zero.y && n.x <= @max.x && n.y <= @max.y }
    end

    def connects?(_coordinate)
      connects_to.include?
    end

    def blank?
      @symbol == '.'
    end

    def start?
      @symbol == 'S'
    end
  end
end
