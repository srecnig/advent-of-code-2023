# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/boilerplate/something'

class SomethingTest < Minitest::Test
  include Something
end
