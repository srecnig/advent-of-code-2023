require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../lib/dec-02/cube_conundrum'

class CubeConundrumTest < Minitest::Test
    def test_valid
        bag = CubeConundrum::Bag.new(red=10, green=10, blue=10)
        game1 = CubeConundrum::Game.new(id=7, red=11, green=10, blue=9)
        game2 = CubeConundrum::Game.new(id=7, red=9, green=11, blue=10)
        game3 = CubeConundrum::Game.new(id=7, red=10, green=9, blue=11)
        game4 = CubeConundrum::Game.new(id=7, red=10, green=10, blue=10)
        game5 = CubeConundrum::Game.new(id=7, red=9, green=9, blue=9)

        assert_equal false, bag.valid?(game1)
        assert_equal false, bag.valid?(game2)
        assert_equal false, bag.valid?(game3)
        assert_equal true, bag.valid?(game4)
        assert_equal true, bag.valid?(game5)
    end

    def test_parsing
        games = CubeConundrum::Game.parse("Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red")
        assert_equal 4, games[0].id
        assert_equal 3, games[0].red
        assert_equal 1, games[0].green
        assert_equal 6, games[0].blue

        assert_equal 4, games[1].id
        assert_equal 6, games[1].red
        assert_equal 3, games[1].green
        assert_equal 0, games[1].blue

        assert_equal 4, games[2].id
        assert_equal 14, games[2].red
        assert_equal 3, games[2].green
        assert_equal 15, games[2].blue
    end

    def test_all_valid
        bag = CubeConundrum::Bag.new(red=2, blue=2, green=2)
        game1 = CubeConundrum::Game.new(id=1, red=3, blue=3, green=3)
        game2 = CubeConundrum::Game.new(id=1, red=2, blue=2, green=2)
        assert_equal false, bag.all_valid?([game1, game2])
        assert_equal true, bag.all_valid?([game2, game2])
    end
end