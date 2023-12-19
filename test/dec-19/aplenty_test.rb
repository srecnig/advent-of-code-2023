# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-19/aplenty'

class AplentyTest < Minitest::Test
  include Aplenty

  def test_can_initialize_workflow
    workflow = Workflow.new('px{a<2006:qkq,m>2090:A,rfg}')
    assert_equal 'px', workflow.name
    assert_equal Rule.new('a<2006', 'qkq'), workflow.rules[0]
    assert_equal Rule.new('m>2090', 'A'), workflow.rules[1]
    assert_equal Rule.new(nil, 'rfg'), workflow.rules[2]
  end

  def test_can_initialize_workflow_map
    workflows = [
      'px{a<2006:qkq,m>2090:A,rfg}',
      'rfg{s<537:gd,x>2440:R,A}'

    ]
    parts = [
      '{x=787,m=2655,a=1222,s=2876}',
      '{x=1679,m=44,a=2067,s=496}',
      '{x=2036,m=264,a=79,s=2244}'
    ]
    workflow_map = WorkflowMap.new(workflows, parts)
    assert_equal Rule.new('a<2006', 'qkq'), workflow_map['px'].rules[0]
    assert_equal Rule.new('m>2090', 'A'), workflow_map['px'].rules[1]
    assert_equal Rule.new(nil, 'rfg'), workflow_map['px'].rules[2]

    assert_equal Rule.new('s<537', 'gd'), workflow_map['rfg'].rules[0]
    assert_equal Rule.new('x>2440', 'R'), workflow_map['rfg'].rules[1]
    assert_equal Rule.new(nil, 'A'), workflow_map['rfg'].rules[2]

    assert_equal Part.new(787, 2655, 1222, 2876), workflow_map.parts[0]
    assert_equal Part.new(1679, 44, 2067, 496), workflow_map.parts[1]
    assert_equal Part.new(2036, 264, 79, 2244), workflow_map.parts[2]
  end
end
