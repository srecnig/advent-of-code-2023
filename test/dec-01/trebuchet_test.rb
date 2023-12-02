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
end


class DigitizeWords < Minitest::Test
  def test_digitize_words
      assert_equal '219', digitize_string('two1nine')
      assert_equal '8wo3', digitize_string('eightwothree')
      assert_equal 'abc123xyz', digitize_string('abcone2threexyz')
      assert_equal 'x2ne34', digitize_string('xtwone3four')
      assert_equal '49872', digitize_string('4nineeightseven2')
      assert_equal 'z1ight234', digitize_string('zoneight234')
      assert_equal '7pqrst6teen', digitize_string('7pqrstsixteen')
  end
end
