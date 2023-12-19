# frozen_string_literal: true

module Aplenty
  Part = Struct.new(:x, :m, :s, :a)

  Rule = Struct.new(:condition, :destination)

  class WorkflowMap
    attr_reader :parts

    def initialize(workflows, parts)
      @workflows = workflows.each.with_object({}) do |definition, wf|
        workflow = Workflow.new(definition)
        wf[workflow.name] = workflow
      end
      @parts = parts.map do |definition|
        values = definition[1..-2].split(',').map { |v| v.split('=')[1].to_i }
        Part.new(values[0], values[1], values[2], values[3])
      end
    end

    def [](key)
      @workflows[key]
    end
  end

  class Workflow
    attr_reader :name, :rules

    def initialize(definition)
      @name = definition.split('{')[0]
      @rules = definition.split('{')[1][..-2].split(',').map do |rulestr|
        if rulestr.include?(':')
          condition, destination = rulestr.split(':')
          Rule.new(condition, destination)
        else
          Rule.new(nil, rulestr)
        end
      end
    end
  end
end
