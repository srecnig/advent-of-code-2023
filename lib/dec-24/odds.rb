# frozen_string_literal: true

require 'matrix'

module Odds
  class Hailstones
    def initialize(lines, area_min, area_max)
      @hailstones = lines.map { |line| Hailstone.new(line) }
      @area_min = area_min
      @area_max = area_max
    end

    def count_collisions
      @hailstones.combination(2).reduce(0) do |memo, (hailstone_a, hailstone_b)|
        collision_point = hailstone_a.collide(hailstone_b)
        if collision_point &&
           !hailstone_a.in_past?(collision_point) &&
           !hailstone_b.in_past?(collision_point) &&
           collision_point[0] >= @area_min && collision_point[0] <= @area_max &&
           collision_point[1] >= @area_min && collision_point[1] <= @area_max
          memo + 1
        else
          memo
        end
      end
    end
  end

  class Hailstone
    attr_reader :pos0, :k, :d

    def initialize(line)
      parsed = line.split('@').map { |s| s.split(',').map(&:strip).map(&:to_i) }
      @pos0 = Vector[*parsed[0][0..-2]]
      @velocity = Vector[*parsed[1][0..-2]]

      @pos1 = pos_at(1)
      @k = (@pos1[1] - @pos0[1].to_f) / (@pos1[0] - @pos0[0].to_f)
      @d = @pos0[1] - (@k * @pos0[0])
    end

    def pos_at(ns)
      @pos0 + (ns * @velocity)
    end

    def collide(hailstone)
      return nil if @k == hailstone.k

      x = (hailstone.d - @d) / (@k - hailstone.k)
      y = (@k * x) + @d
      Vector[x.round(3), y.round(3)]
    end

    def in_past?(point)
      if @velocity[0].positive?
        point[0] < @pos0[0]
      else
        point[0] > @pos0[0]
      end
    end
  end
end
