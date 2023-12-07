# frozen_string_literal: true

module WaitForIt
  Race = Struct.new(:duration, :record)
  Strategy = Struct.new(:holding_duration, :distance, :winning?)

  def self.calculate_strategies(race)
    (0..race.duration).map do |holding_duration|
      velocity = holding_duration
      travel_time = race.duration - holding_duration
      distance = velocity * travel_time
      Strategy.new(holding_duration, distance, distance > race.record)
    end
  end
end
