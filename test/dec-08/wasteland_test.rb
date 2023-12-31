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
    assert_equal :EEE, node_map.next_step(:AAA, :right)
    assert_equal :ZZZ, node_map.next_step(:EEE, :left)
  end

  def test_traversing_works
    node_map = NodeMap.new('RL', ['AAA = (BBB, CCC)', 'CCC = (ZZZ, GGG)', 'ZZZ = (ZZZ, ZZZ)'])
    assert_equal 2, node_map.traverse!
  end

  def test_traversing_multiples_works
    node_strings = [
      '11A = (11B, XXX)',
      '11B = (XXX, 11Z)',
      '11Z = (11B, XXX)',
      '22A = (22B, XXX)',
      '22B = (22C, 22C)',
      '22C = (22Z, 22Z)',
      '22Z = (22B, 22B)',
      'XXX = (XXX, XXX)'
    ]
    node_map = NodeMap.new('LR', node_strings)
    assert_equal 6, node_map.traverse_multiple!
  end
end
