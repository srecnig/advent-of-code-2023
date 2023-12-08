# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-08/wasteland'

class WastelandTest < Minitest::Test
  include Wasteland

  def test_nodemap_initialization_works
    node_map = NodeMap.new('RL', ['AAA = (BBB, CCC)', 'EEE = (EEE, EEE)', 'ZZZ = (ZZZ, ZZZ)'])
    assert_equal Node.new(:AAA, :BBB, :CCC), node_map[:AAA]
    assert_equal Node.new(:EEE, :EEE, :EEE), node_map[:EEE]
    assert_equal Node.new(:ZZZ, :ZZZ, :ZZZ), node_map[:ZZZ]
  end

  def test_instructions_are_endless
    node_map = NodeMap.new('RRL', [])
    assert_equal :right, node_map.instructions.next
    assert_equal :right, node_map.instructions.next
    assert_equal :left, node_map.instructions.next
    assert_equal :right, node_map.instructions.next
    assert_equal :right, node_map.instructions.next
    assert_equal :left, node_map.instructions.next
    assert_equal :right, node_map.instructions.next
    assert_equal :right, node_map.instructions.next
    assert_equal :left, node_map.instructions.next
    assert_equal :right, node_map.instructions.next
    assert_equal :right, node_map.instructions.next
    assert_equal :left, node_map.instructions.next
  end

  def test_next_step_works
    node_map = NodeMap.new('RL', ['AAA = (BBB, EEE)', 'EEE = (ZZZ, EEE)', 'ZZZ = (ZZZ, ZZZ)'])
    assert_equal :EEE, node_map.next_step(:AAA) # instruction on 'R'
    assert_equal :ZZZ, node_map.next_step(:EEE) # instrunction on 'L'
  end

  def test_traversing_works
    node_map = NodeMap.new('RL', ['AAA = (BBB, CCC)', 'CCC = (ZZZ, GGG)', 'ZZZ = (ZZZ, ZZZ)'])
    assert_equal 2, node_map.traverse!
  end
end
