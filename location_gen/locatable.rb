
module Locatable
  attr_reader :lat, :long

  def self.included other
    other.extend ClassMethods
  end

  def distance_to other_lat, other_long
    Haversine.distance(@lat, @long, other_lat, other_long).to_miles
  end

  module ClassMethods
    def near lat, long
      close_stations = self.all_stations.select do |station|
        station.distance_to(lat, long) < CLOSE_RADIUS
      end
    end
  end
end
