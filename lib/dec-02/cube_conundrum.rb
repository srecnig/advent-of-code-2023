module CubeConundrum
  class Bag
    attr_reader :red, :green, :blue

    def self.minimum_bag(games)
      max_red = games.max_by(&:red).red
      max_blue = games.max_by(&:blue).blue
      max_green = games.max_by(&:green).green
      Bag.new(red=max_red, green=max_green, blue=max_blue)
    end

    def initialize(red, green, blue)
      @red = red
      @green = green
      @blue = blue
    end

    def valid?(game)
      if game.red <= @red && game.green <= @green && game.blue <= @blue
        return true
      else
        return false
      end
    end

    def all_valid?(games)
      games.all? { |game| valid?(game) }
    end

    def power()
      @red * @green * @blue 
    end
  end

  class Game
    attr_reader :id, :red, :green, :blue

    def self.parse(string)
      id = string.split(':')[0].split(' ')[1] .to_i
      game_strings = string.split(':')[1].strip.split(';').map(&:strip)
      games = []
      for game_string in game_strings do
        red_match = game_string.match(/\s*(\d+)\sred/)
        green_match = game_string.match(/\s*(\d+)\sgreen/)
        blue_match = game_string.match(/\s*(\d+)\sblue/)
        red = (red_match && red_match.captures[0].to_i) || 0
        green = (green_match && green_match.captures[0].to_i) || 0
        blue = (blue_match && blue_match.captures[0].to_i) || 0
        game = Game.new(id=id, red=red, green=green, blue=blue)
        games << game
      end
      games
    end

    def initialize(id, red, green, blue)
      @id = id
      @red = red
      @green = green
      @blue = blue
    end
  end
end