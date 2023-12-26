# frozen_string_literal: true

module Lavaduct
  Command = Struct.new(:direction, :steps, :color)
  Point = Struct.new(:coordinate, :color, :inside, :edge_type)
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
      @column_count = west_east.max - west_east.min + 1
      @x_offset = west_east.min

      north_south = @commands.filter do |c|
        c.direction == :north || c.direction == :south
      end
      north_south = north_south.map.with_object([0]) do |c, m|
        location_change = c.direction == :south ? m[-1] + c.steps : m[-1] - c.steps
        m << location_change
      end
      @row_count = north_south.max - north_south.min + 1
      @y_offset = north_south.min

      @map = Array.new(@row_count) { Array.new(@column_count) }
      @row_count.times do |y_pos|
        @column_count.times do |x_pos|
          @map[y_pos][x_pos] = Point.new(Coordinate.new(x_pos, y_pos), nil, false)
        end
      end
    end

    def dig!
      current = Coordinate.new(@x_offset.abs, @y_offset.abs)

      @commands.each.with_index do |command, i|
        edge_type = case @commands[i - 1].direction
                    when :north
                      command.direction == :east ? 'F' : '7'
                    when :east
                      command.direction == :north ? 'J' : '7'
                    when :south
                      command.direction == :east ?  'L' : 'J'
                    when :west
                      command.direction == :north ? 'L' : 'F'
                    end
        @map[current.y][current.x].edge_type = edge_type

        command.steps.times do |step|
          point = @map[current.y][current.x]
          point.color = command.color
          point.inside = true
          case command.direction
          when :north
            current.y -= 1
            point.edge_type = '|' unless step.zero?
          when :east
            current.x += 1
            point.edge_type = '-' unless step.zero?
          when :south
            current.y += 1
            point.edge_type = '|' unless step.zero?
          when :west
            current.x -= 1
            point.edge_type = '-' unless step.zero?
          end
        end
      end
      # now that we got the loop, decide what's in or out
      @map.each.with_index do |row, _y_pos|
        edges = row.reject { |p| p.edge_type.nil? || p.edge_type == '-' }
        normalized_edges = edges.each.with_index.with_object([]) do |(edge, i), arr|
          next_edge = edges[i + 1]
          next if (edge.edge_type == 'L' && next_edge && next_edge.edge_type == '7') ||
                  (edge.edge_type == 'F' && next_edge && next_edge.edge_type == 'J')

          arr << edge
        end

        row.each.with_index do |point, _i|
          next if point.inside

          edge_count = normalized_edges.select { |e| e.coordinate.x > point.coordinate.x }.length
          point.inside = edge_count.odd?
        end
      end
    end

    def diggings
      @map.inject(0) do |overall_count, row|
        row_count = row.inject(0) do |rc, p|
          p.inside ? rc + 1 : rc
        end
        overall_count + row_count
      end
    end

    def print
      @map.each do |line|
        pr_line = ''
        line.each do |point|
          char = if point.edge_type
                   point.edge_type
                 elsif point.inside
                   '#'
                 else
                   '.'
                 end
          pr_line += char
        end
      end
    end
  end
end
