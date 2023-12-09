# frozen_string_literal: true

module Mirage
  class History
    attr_reader :values, :expanded, :predicted, :redicted

    def initialize(history_string)
      @values = history_string.split.map(&:to_i)
      @expanded = [@values]
      expand!
      predict!
      redict!
    end

    def next_row(row)
      row.each_cons(2).map { |a, b| b - a }
    end

    def expand!
      @expanded = [@values]
      row = @values
      loop do
        row = next_row(row)
        @expanded << row
        break if row.all?(&:zero?)
      end
    end

    def predict!
      @predicted = @expanded.inject([]) { |m, l| m << l.clone }
      @predicted[-1] << 0
      @predicted.reverse.each_cons(2) do |l, n|
        n << (l[-1] + n[-1])
      end
    end

    # redict is the opposite of predict, right?!
    def redict!
      @redicted = @expanded.inject([]) { |m, l| m << l.clone }
      @redicted[-1].unshift(0)
      @redicted.reverse.each_cons(2) do |l, n|
        n.unshift(n[0] - l[0])
      end
    end
  end
end
