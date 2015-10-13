require "did_you_mean"
require "httparty"
require "haversine"

require "./location_gen/locatable"
require "./location_gen/station"
require "./location_gen/bike_station"
require "./location_gen/bus"

CLOSE_RADIUS = 1

class Travelmodes
  attr_accessor :latitude, :longitude

  def initialize latitude, longitude
    @lat= latitude|| 38.905829
    @long = longitude|| -77.043536

  end

  def create_table

    bikes = BikeStation.near(@lat, @long)
    metros = Station.near(@lat, @long)
    bus = Bus.near(@lat, @long)
    info = []
    all_stations = (bikes + metros + bus).sort_by {|s| s.distance_to(@lat, @long)}
    all_stations.first(20).each do |station|
      stuff = {
        :name => station.name,
        :distance => station.distance_to(@lat, @long).round(2),
        :details => station.extra_detail
      }
      info.push(stuff)
    end
     info
  end
end
