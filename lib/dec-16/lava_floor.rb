# frozen_string_literal: true

module LavaFloor
  class Contraption
    def initialize(lines)
      column_count = lines[0].length
      row_count = lines.length
      @zero = Coordinate.new(0, 0)
      @max = Coordinate.new(column_count - 1, row_count - 1)
      @points = Array.new(row_count) { Array.new(column_count) }
      lines.each_with_index do |row, y_index|
        row.each_char.with_index do |char, x_index|
          new_point = Point.new(
            Coordinate.new(x_index, y_index), char
          )
          @points[y_index][x_index] = new_point
        end
      end
    end

    def [](coordinate)
      @points[coordinate.y][coordinate.x]
    end

    def in_bounds?(coordinate)
      coordinate.x <= @max.x && coordinate.y <= @max.y && coordinate.x >= @zero.x && coordinate.y >= @zero.y
    end
  end

  Coordinate = Struct.new(:x, :y)

  Point = Struct.new(:coordinate, :character, :energized) do
    def pass_through(from)
      directions = pass_through_direction(from)
      directions.map do |direction|
        case direction
        when :north
          Coordinate.new(coordinate.x, coordinate.y - 1)
        when :east
          Coordinate.new(coordinate.x + 1, coordinate.y)
        when :south
          Coordinate.new(coordinate.x, coordinate.y + 1)
        when :west
          Coordinate.new(coordinate.x - 1, coordinate.y)
        end
      end
    end

    def pass_through_direction(from)
      if empty_space?
        paths = {
          north: [:south],
          east: [:west],
          south: [:north],
          west: [:east]
        }
        paths[from]
      elsif splitter?
        split(from)
      elsif mirror?
        reflect(from)
      end
    end

    def empty_space?
      character == '.'
    end

    def splitter?
      character == '|' || character == '-'
    end

    def split(from)
      splits = {
        '|': {
          north: [:south],
          east: %i[north south],
          south: [:north],
          west: %i[north south]
        },
        '-': {
          north: %i[east west],
          east: [:west],
          south: %i[east west],
          west: [:east]
        }
      }
      splits[character.to_sym][from]
    end

    def mirror?
      character == '/' || character == '\\'
    end

    def reflect(from)
      reflections = {
        '/': {
          north: [:west],
          east: [:south],
          south: [:east],
          west: [:north]
        },
        '\\': {
          north: [:east],
          east: [:north],
          south: [:west],
          west: [:south]
        }
      }
      reflections[character.to_sym][from]
    end
  end
end
