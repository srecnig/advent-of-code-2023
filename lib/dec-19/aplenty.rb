# frozen_string_literal: true

module Aplenty
  Part = Struct.new(:x, :m, :a, :s, :status) do
    def sum
      x + m + s + a
    end
  end

  Rule = Struct.new(:condition, :destination) do
    def apply_rule(part)
      if condition&.include?('<')
        comparator = :<
        (prop, value) = condition.split('<').map(&:strip)
      elsif condition&.include?('>')
        comparator = :>
        (prop, value) = condition.split('>').map(&:strip)
      else
        return destination
      end

      if part.send(prop).send(comparator, value.to_i)
        destination
      else
        false
      end
    end
  end

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

    def process_parts!
      @parts.each do |part|
        workflow = 'in'
        loop do
          next_step = self[workflow].apply_workflow(part)
          if next_step == 'A'
            part.status = :accepted
            break
          elsif next_step == 'R'
            part.status = :rejected
            break
          else
            workflow = next_step
            next
          end
        end
      end
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

    def apply_workflow(part)
      @rules.each do |rule|
        evaluated = rule.apply_rule(part)
        return evaluated unless evaluated == false
      end
    end
  end
end
