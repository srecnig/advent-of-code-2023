# frozen_string_literal: true

module Wasteland
  Node = Struct.new(:address, :left, :right)
  TraversalNode = Struct.new(:node, :done, :end_step)

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

    def next_step(position, instruction)
      @nodes[position].send(instruction)
    end

    def traverse!(start = :AAA)
      position = start
      steps_taken = 0

      loop do
        next_instruction = @instructions.next
        position = self[next_step(position, next_instruction)].address
        steps_taken += 1
        break if position == :ZZZ
      end
      steps_taken
    end

    def traverse_multiple!
      start_nodes = @nodes.select { |address, _node| address.to_s.end_with?('A') }.values
      traversal_nodes = start_nodes.map { |node| TraversalNode.new(node, false, nil) }
      steps_taken = 0

      loop do
        next_instruction = @instructions.next
        steps_taken += 1

        traversal_nodes.each do |tn|
          tn.node = self[next_step(tn.node.address, next_instruction)]
          endpoint = tn.node.address.to_s.end_with?('Z')
          if endpoint
            tn.done = true
            tn.end_step = steps_taken
          end
        end
        break if traversal_nodes.all?(&:done)
      end
      # we're lucky that all end_steps are exact multiples of the # of total instructions and not
      # a single endpoint is reached without one full cycle of instructions.
      traversal_nodes.reduce(1) { |r, node| r.lcm(node.end_step) }
    end

    def [](key)
      @nodes[key]
    end
  end
end
