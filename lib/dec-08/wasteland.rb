# frozen_string_literal: true

module Wasteland
  Node = Struct.new(:address, :left, :right)

  class NodeMap
    attr_reader :nodes, :instructions

    def initialize(instruction_line, map_lines)
      @instructions = instruction_line.each_char.map { |c| c == 'R' ? :right : :left }.cycle
      node_list = map_lines.map do |line|
        address = line.split('=').map(&:strip)[0]
        (left, right) = line.split('=').map(&:strip)[1].tr('()', '').split(',').map(&:strip)
        [address.to_sym, Node.new(address.to_sym, left.to_sym, right.to_sym)]
      end
      @nodes = node_list.to_h
    end

    def next_step(position)
      @nodes[position].send(@instructions.next)
    end

    def traverse!(start = :AAA)
      position = start
      steps_taken = 0

      loop do
        position = self[next_step(position)].address
        steps_taken += 1
        break if position == :ZZZ
      end
      steps_taken
    end

    def [](key)
      @nodes[key]
    end
  end
end
