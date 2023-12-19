# frozen_string_literal: true

require_relative 'aplenty'

def main1(filepath)
  file_content = File.read(File.join(File.dirname(__FILE__), filepath), chomp: true)
  blocks = file_content.split("\n\n")
  workflows = blocks[0].split("\n")
  parts = blocks[1].split("\n")
  workflows = Aplenty::WorkflowMap.new(workflows, parts)
  workflows.process_parts!
  p workflows.parts.filter { |p| p.status == :accepted }.reduce(0) { |m, p| m + p.sum }
end

def main2(filepath)
  something = File.readlines(File.join(File.dirname(__FILE__), filepath), chomp: true)
  p something
end

main1('input.txt')
