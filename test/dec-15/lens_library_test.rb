# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-15/lens_library'

class LensLibraryTest < Minitest::Test
  include LensLibrary

  def test_hash
    assert_equal 52, LensLibrary.hash('HASH')
    assert_equal 30, LensLibrary.hash('rn=1')
    assert_equal 214, LensLibrary.hash('pc=6')
    assert_equal 231, LensLibrary.hash('ot=7')
  end
end
