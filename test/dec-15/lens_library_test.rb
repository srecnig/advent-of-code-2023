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

  def test_hash_map
    hash_map = HashMap.new
    lens = Lens.new('rn', 1)
    hash_map.operate!(lens, :set)
    assert_equal [Lens.new('rn', 1)], hash_map['rn'].content
    lens = Lens.new('cm', nil)
    hash_map.operate!(lens, :remove)
    assert_equal [Lens.new('rn', 1)], hash_map['rn'].content
    lens = Lens.new('qp', 3)
    hash_map.operate!(lens, :set)
    assert_equal [Lens.new('rn', 1)], hash_map['rn'].content
    assert_equal [Lens.new('qp', 3)], hash_map['qp'].content
    lens = Lens.new('cm', 2)
    hash_map.operate!(lens, :set)
    assert_equal [Lens.new('rn', 1), Lens.new('cm', 2)], hash_map['rn'].content
    assert_equal [Lens.new('rn', 1), Lens.new('cm', 2)], hash_map['cm'].content
    assert_equal [Lens.new('qp', 3)], hash_map['qp'].content
    assert_equal 1, hash_map.focusing_power('rn')
    assert_equal 4, hash_map.focusing_power('cm')
    assert_equal 6, hash_map.focusing_power('qp')
  end
end
