# frozen_string_literal: true

module PipeMaze
  Coordinate = Struct.new(:x, :y)

  class PipeMap
    attr_reader :start, :path

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

    def follow_start!
      potentially_connected_points = @start.connects_to.map { |c| self[c] }
      connected_points = potentially_connected_points.select { |p| p.connects?(@start) }
      @path = explore_route(start_point: connected_points[0], end_point: @start)
      @path.each do |point|
        point.in_path = true
        point.outside = false
      end

      # set start to the proper logical_char
      case connected_points.map(&:coordinate)
      when [@start.north, @start.south]
        @start.logical_char = '|'
      when [@start.east, @start.west]
        @start.logical_char = '-'
      when [@start.north, @start.east]
        @start.logical_char = 'L'
      when [@start.north, @start.west]
        @start.logical_char = 'J'
      when [@start.south, @start.west]
        @start.logical_char = '7'
      when [@start.east, @start.south]
        @start.logical_char = 'F'
      end
    end

    def explore_route(start_point:, end_point:)
      steps = []
      last_point = end_point
      current_point = start_point
      loop do
        steps << current_point
        next_coordinate = current_point.connects_to.reject { |c| c == last_point.coordinate }.first
        # if nil, there's no next coordinate, we're in a dead end.
        return if next_coordinate.nil?
        # if we're at the actual end
        break if next_coordinate == end_point.coordinate

        last_point = current_point
        current_point = self[next_coordinate]
      end
      steps << end_point
      steps
    end

    def calculate_inside!
      @points.each do |row|
        edges = row.select { |p| p.in_path && p.edge? }
        normalized_edges = edges.each.with_index.with_object([]) do |(edge, i), arr|
          next_edge = edges[i + 1]

          next if (edge.char == 'L' && next_edge && next_edge.char == '7') ||
                  (edge.char == 'F' && next_edge && next_edge.char == 'J')

          arr << edge
        end

        row.each.with_index do |point, _i|
          next if point.in_path

          edge_count = normalized_edges.select { |e| e.coordinate.x > point.coordinate.x }.length
          point.outside = edge_count.even?
        end
      end
    end

    def inside_points
      @points.flatten.select { |p| !p.outside && !p.in_path }
    end

    def print_inside
      p ''
      @points.each do |line|
        output = line.map do |p|
          if p.in_path
            p.char
          elsif p.outside.nil?
            'N'
          elsif p.outside
            'O'
          else
            'I'
          end
        end
        puts output.join
      end
    end
  end

  class Point
    attr_reader :char, :coordinate
    attr_accessor :in_path, :logical_char, :outside, :flips_inside_out

    def initialize(char, coordinate, max_coordinates)
      @char = char
      @logical_char = char
      @coordinate = coordinate
      @in_path = false
      @outside = nil
      @flips_inside_out = nil
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
      case @logical_char
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
      when 'S'
        connecting = [north, east, south, west]
      when '.'
        []
      end
      connecting.filter { |n| n.x >= @zero.x && n.y >= @zero.y && n.x <= @max.x && n.y <= @max.y }
    end

    def edge?
      ['|', 'L', 'J', '7', 'F'].include?(@logical_char)
    end

    def connects?(point)
      connects_to.include?(point.coordinate)
    end

    def blank?
      @char == '.'
    end

    def start?
      @char == 'S'
    end
  end
end

# kante is im path.
# ausnahme, der davor war auch eine kante

# O|II|O|II|O
#     1 2  3  -> I

# def calculate_inside!
#   p 'aaah' * 6
#   @points.each.with_index do |row, i|
#     debug = true if i == 2
#     # if outside is not set at the beginning of a line, it must be outside
#     row[0].outside = true if row[0].outside.nil?

#     row.each_cons(2).map do |last_point, current_point|
#       # we flip, because we go from outside to inside
#       current_point.flips_inside_out = true if last_point.outside && current_point.outside == false
#       # we flip, because we go from inside to outside
#       last_point.flips_inside_out = true if last_point.outside == false && current_point.outside.nil?
#       # lastly, if we have non connected path points, both are flippers
#       if last_point.outside == false && current_point.outside == false && !current_point.connects?(last_point)
#         last_point.flips_inside_out = true
#         current_point.flips_inside_out = true
#       end
#     end
#     p row if debug
#   end

#   # we now the flippers for every line. so for every line, go by point and set
#   @points.each do |row|
#     outside = row[0].outside
#     row.each do |point|
#       outside = !outside if point.flips_inside_out
#       point.outside = outside if point.outside.nil?
#     end
#   end
# end
