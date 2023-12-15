# frozen_string_literal: true

module ReflectorDish
  class Dish
    attr_reader :columns, :rows

    def initialize(lines)
      @rows = lines.map { |l| l.each_char.map { |c| Ground.new(c) } }
      @columns = (0...(lines[0].length)).each.map { |i| @rows.map { |r| r[i] } }
    end

    def tilt_north!
      new_columns = @columns.each.map do |column|
        tilt_column(column)
      end
      @columns = new_columns
    end

    def tilt_column(column)
      new_column = column.slice_before(&:cube_rock?).map do |part|
        next part if part.length == 1 # don't need to do anything if it's just one part

        cube_rocks = part.count(&:cube_rock?)
        round_rocks = part.count(&:round_rock?)
        blanks = part.length - cube_rocks - round_rocks

        new_part = []
        cube_rocks.times { new_part << Ground.new('#') }
        round_rocks.times { new_part << Ground.new('O') }
        blanks.times { new_part << Ground.new('.') }
        new_part
      end
      new_column.flatten
    end

    def total_load
      @columns.inject(0) do |total_load, column|
        total_load + column.each.with_index.inject(0) do |column_load, (ground, i)|
          if ground.round_rock?
            column_load + column.length - i
          else
            column_load
          end
        end
      end
    end
  end

  Ground = Struct.new(:ground) do
    def empty_space?
      ground == '.'
    end

    def cube_rock?
      ground == '#'
    end

    def round_rock?
      ground == 'O'
    end
  end
end
