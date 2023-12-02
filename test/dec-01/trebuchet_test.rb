# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/dec-01/trebuchet'

class DigitTest < Minitest::Test
  def test_digit?
    assert_equal true, digit?('5')
    assert_equal false, digit?('x')
    assert_equal false, digit?('🐸')
  end
end

class ExtractNumber < Minitest::Test
  def test_extract_number
    assert_equal 12, extract_number('abc1defg2')
    assert_equal 82, extract_number('abc88888888882')
    assert_equal 33, extract_number('a3b')
    assert_nil extract_number('abcdefg')
  end

  def test_digitize
    assert_equal 29, extract_number('two1nine', digitize: true)
    assert_equal 83, extract_number('eightwothree', digitize: true)
    assert_equal 13, extract_number('abcone2threexyz', digitize: true)
    assert_equal 24, extract_number('xtwone3four', digitize: true)
    assert_equal 42, extract_number('4nineeightseven2', digitize: true)
    assert_equal 14, extract_number('zoneight234', digitize: true)
    assert_equal 76, extract_number('7pqrstsixteen', digitize: true)
    assert_equal 82, extract_number('eightwo', digitize: true)
  end
end
