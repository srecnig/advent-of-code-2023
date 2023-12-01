require 'minitest/autorun'
require_relative '../../lib/dec-01/trebuchet1'

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
    assert_nil, extract_number('abcdefg')
  end
end