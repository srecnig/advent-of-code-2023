# frozen_string_literal: true

module Lavaduct
  Command = Struct.new(:direction, :steps, :color)
  Point = Struct.new(:coordinate, :color, :inside)
  Coordinate = Struct.new(:x, :y)

  class DiggingManual
    attr_reader :commands, :column_count, :row_count

    def initialize(lines)
      @commands = lines.map do |line|
        (direction, steps, color) = line.split
        direction_mapping = { U: :north, R: :east, D: :south, L: :west }
        Command.new(direction_mapping[direction.to_sym], steps.to_i, color[1..-2])
      end

      west_east = @commands.filter { |c| c.direction == :east || c.direction == :west }.map.with_object([0]) do |c, m|
        location_change = c.direction == :east ? m[-1] + c.steps : m[-1] - c.steps
        m << location_change
      end
      @column_count = west_east.max + 1

      north_south = @commands.filter do |c|
        c.direction == :north || c.direction == :south
      end
      north_south = north_south.map.with_object([0]) do |c, m|
        location_change = c.direction == :south ? m[-1] + c.steps : m[-1] - c.steps
        m << location_change
      end
      @row_count = north_south.max + 1

      @map = Array.new(@row_count) { Array.new(@column_count) }
      @row_count.times do |y_pos|
        @column_count.times do |x_pos|
          @map[y_pos][x_pos] = Point.new(Coordinate.new(x_pos, y_pos), nil, false)
        end
      end
    end

    def dig!
      # start at 0/0, go through every command and color the points
      current = Coordinate.new(0, 0)
      @commands.each do |command|
        command.steps.times do |_i|
          point = @map[current.y][current.x]
          point.color = command.color
          point.inside = true
          case command.direction
          when :north
            current.y -= 1
          when :east
            current.x += 1
          when :south
            current.y += 1
          when :west
            current.x -= 1
          end
        end
      end
      # now that we got the loop, decide what's in or out
      @row_count.times do |y_pos|
        edges = @map[y_pos].each_index.select { |x_pos| @map[y_pos][x_pos].inside }.reverse
        normalized_edges = edges.each_index.with_object([]) do |x, m|
          m << edges[x] if edges[x + 1].nil? || edges[x] - edges[x + 1] > 1
        end
        normalized_edges.reverse!
        p '---' * 5
        p edges
        p normalized_edges

        @column_count.times do |x_pos|
          next if @map[y_pos][x_pos].inside

          # edge_count = normalized_edges.select { |x| x > x_pos }.length
          # @map[y_pos][x_pos].inside = edge_count.odd?
        end
      end
    end

    # def calculate_inside!
    #   @points.each do |row|
    #     edges = row.select(&:edge?)
    #     normalized_edges = edges.each.with_index.with_object([]) do |(edge, i), arr|
    #       next_edge = edges[i + 1]

    #       next if (edge.char == 'L' && next_edge && next_edge.char == '7') ||
    #               (edge.char == 'F' && next_edge && next_edge.char == 'J')

    #       arr << edge
    #     end

    #     row.each.with_index do |point, _i|
    #       next if point.in_path

    #       edge_count = normalized_edges.select { |e| e.coordinate.x > point.coordinate.x }.length
    #       point.outside = edge_count.even?
    #     end
    #   end
    # end

    def print
      p 'geili'
      @map.each do |line|
        pr_line = ''
        line.each { |point| pr_line += (point.inside ? '#' : '.') }
        p pr_line
      end
    end
  end
end

# @points = Array.new(row_count) { Array.new(column_count) }
# lines.each_with_index do |line, y_index|
#   line.each_char.with_index do |char, x_index|
#     new_point = Point.new(
#       char, Coordinate.new(x_index, y_index), max_coordinates
#     )
#     @points[y_index][x_index] = new_point
#     @start = new_point if new_point.start?
#   end
# end
