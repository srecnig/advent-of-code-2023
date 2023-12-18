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
    attr_reader :galaxy_points

    def initialize(lines, expansion_rate)
      @expansion_rate = expansion_rate - 1
      @column_count = lines[0].length
      @row_count = lines.length
      @points = Array.new(@row_count) { Array.new(@column_count) }
      @galaxy_points = []
      lines.each_with_index do |row, y_index|
        row.each_char.with_index do |char, x_index|
          new_point = Point.new(
            Coordinate.new(x_index, y_index), char
          )
          @points[y_index][x_index] = new_point
          @galaxy_points << new_point if new_point.galaxy?
        end
      end
      expand!
    end

    def [](coordinate)
      @points[coordinate.y][coordinate.x]
    end

    def expand!
      add_y_index = []
      @points.each.with_index do |row, y|
        add_y_index << y if row.all?(&:empty_space?)
      end
      add_x_index = []
      (0...@column_count).each do |x|
        column_empty = (0...@row_count).all? { |y| self[Coordinate.new(x, y)].empty_space? }
        add_x_index << x if column_empty
      end

      add_y_index.reverse.each do |y|
        @galaxy_points.select { |p| p.coordinate.y > y  }.each do |p|
          p.coordinate = Coordinate.new(p.coordinate.x, p.coordinate.y + @expansion_rate)
        end
      end
      add_x_index.reverse.each do |x|
        @galaxy_points.select { |p| p.coordinate.x > x }.each do |p|
          p.coordinate = Coordinate.new(p.coordinate.x + @expansion_rate, p.coordinate.y)
        end
      end
    end

    def galaxy_pairs
      @galaxy_points.combination(2)
    end
  end
end
