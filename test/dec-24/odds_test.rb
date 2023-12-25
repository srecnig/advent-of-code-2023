# frozen_string_literal: true

require 'matrix'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-24/odds'

class OddsTest < Minitest::Test
  include Odds

  def test_initialization
    hailstone = Hailstone.new('20, 19, 15 @ 1, -5, -3')
    assert_equal Vector[20, 19], hailstone.pos0
    assert_equal Vector[21, 14], hailstone.pos_at(1)
    assert_equal(-5, hailstone.k)
    assert_equal 119, hailstone.d
  end

  def test_collide
    hailstone_a = Hailstone.new('18, 19, 22 @ -1, -1, -2')
    hailstone_b = Hailstone.new('20, 25, 34 @ -2, -2, -4')
    assert_nil hailstone_a.collide(hailstone_b)
    assert_nil hailstone_b.collide(hailstone_a)

    hailstone_a = Hailstone.new('19, 13, 30 @ -2, 1, -2')
    hailstone_b = Hailstone.new('18, 19, 22 @ -1, -1, -2')
    assert_equal Vector[14.333, 15.333], hailstone_b.collide(hailstone_a)
    assert_equal Vector[14.333, 15.333], hailstone_a.collide(hailstone_b)

    hailstone_a = Hailstone.new('19, 13, 30 @ -2, 1, -2')
    hailstone_b = Hailstone.new('20, 25, 34 @ -2, -2, -4')
    assert_equal Vector[11.667, 16.667], hailstone_b.collide(hailstone_a)
    assert_equal Vector[11.667, 16.667], hailstone_a.collide(hailstone_b)

    hailstone_a = Hailstone.new('19, 13, 30 @ -2, 1, -2')
    hailstone_b = Hailstone.new('12, 31, 28 @ -1, -2, -1')
    assert_equal Vector[6.2, 19.4], hailstone_b.collide(hailstone_a)
    assert_equal Vector[6.2, 19.4], hailstone_a.collide(hailstone_b)

    hailstone_a = Hailstone.new('18, 19, 22 @ -1, -1, -2')
    hailstone_b = Hailstone.new('20, 19, 15 @ 1, -5, -3')
    assert_equal Vector[19.667, 20.667], hailstone_b.collide(hailstone_a)
    assert_equal Vector[19.667, 20.667], hailstone_a.collide(hailstone_b)

    hailstone_a = Hailstone.new('20, 25, 34 @ -2, -2, -4')
    hailstone_b = Hailstone.new('20, 19, 15 @ 1, -5, -3')
    assert_equal Vector[19.0, 24.0], hailstone_b.collide(hailstone_a)
    assert_equal Vector[19.0, 24.0], hailstone_a.collide(hailstone_b)
  end

  def test_in_past
    hailstone_a = Hailstone.new('19, 13, 30 @ -2, 1, -2')
    hailstone_b = Hailstone.new('18, 19, 22 @ -1, -1, -2')
    assert_equal false, hailstone_a.in_past?(Vector[14.333, 15.333])
    assert_equal false, hailstone_b.in_past?(Vector[14.333, 15.333])

    hailstone_a = Hailstone.new('18, 19, 22 @ -1, -1, -2')
    hailstone_b = Hailstone.new('20, 19, 15 @ 1, -5, -3')
    assert_equal true, hailstone_a.in_past?(Vector[19.667, 20.667])
    assert_equal true, hailstone_b.in_past?(Vector[19.667, 20.667])

    hailstone_a = Hailstone.new('20, 25, 34 @ -2, -2, -4')
    hailstone_b = Hailstone.new('20, 19, 15 @ 1, -5, -3')
    assert_equal false, hailstone_a.in_past?(Vector[19.667, 20.667])
    assert_equal true, hailstone_b.in_past?(Vector[19.667, 20.667])
  end
end
