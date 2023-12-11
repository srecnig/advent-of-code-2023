# frozen_string_literal: true

module CosmicExpansion
  Coordinate = Struct.new(:x, :y)

  Point = Struct.new(:coordinate, :char) do
    def empty_space?
      char == '.'
    end

    def galaxy?
      char == '#'
    end

    def distance(other_point)
      (coordinate.x - other_point.coordinate.x).abs + (coordinate.y - other_point.coordinate.y).abs
    end
  end

  class GalaxyMap
    attr_reader :points, :row_count, :column_count

    def initialize(lines)
      @column_count = lines[0].length
      @row_count = lines.length
      @points = Array.new(@row_count) { Array.new(@column_count) }
      lines.each_with_index do |row, y_index|
        row.each_char.with_index do |char, x_index|
          @points[y_index][x_index] = Point.new(
            Coordinate.new(x_index, y_index), char
          )
        end
      end
      expand_vertically!
      expand_horizontally!
      remap!
    end

    def [](coordinate)
      @points[coordinate.y][coordinate.x]
    end

    def expand_vertically!
      add_y_index = []
      @points.each.with_index do |row, y|
        add_y_index << y if row.all?(&:empty_space?)
      end
      add_y_index.reverse.each do |y|
        new_array = Array.new(@column_count) { |x| Point.new(Coordinate.new(x, y - 1), '.') }
        @points.insert(y, new_array)
      end
      @row_count += add_y_index.length
    end

    def expand_horizontally!
      add_x_index = []
      (0...@column_count).each do |x|
        column_empty = (0...@row_count).all? { |y| self[Coordinate.new(x, y)].empty_space? }
        add_x_index << x if column_empty
      end
      add_x_index.reverse.each do |x|
        @points.each.with_index do |row, y|
          row.insert(x, Point.new(Coordinate.new(x - 1, y), '.'))
        end
      end
      @column_count += add_x_index.length
    end

    def remap!
      # coordinates in points are out of sync with actual coordinates. fix.
      @galaxy_points = []
      (0...@row_count).each do |y|
        (0...@column_count).each do |x|
          real_coordinate = Coordinate.new(x, y)
          current = self[real_coordinate]
          # replace with point that for sure has right coordinates + existing char
          new_point = Point.new(real_coordinate, current.char)
          @points[y][x] = new_point
          @galaxy_points << new_point if new_point.galaxy?
        end
      end
    end

    def galaxy_pairs
      @galaxy_points.combination(2)
    end
  end
end
