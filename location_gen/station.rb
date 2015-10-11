class Station
  include Locatable

  attr_reader :name

  def initialize data_hash
    @name = data_hash["Name"]
    @lat  = data_hash["Lat"].to_f
    @long = data_hash["Lon"].to_f
    @code = data_hash["Code"]

  end

  def upcoming_trains
    key = File.read "./location_gen/gitignore/metro_api.txt"
    r = HTTParty.get(
      "https://api.wmata.com/StationPrediction.svc/json/GetPrediction/#{@code}",
      headers: { "api_key" => "#{key}" }
    )
    r["Trains"]
  end

  def self.all_stations
    key = File.read  "./location_gen/gitignore/metro_api.txt"
    r = HTTParty.get(
      "https://api.wmata.com/Rail.svc/json/jStations",
      headers: { "api_key" => "#{key}"  }
    )
    r["Stations"].map { |h| Station.new(h) }
  end

  def extra_detail
    upcoming_trains.map do |train|
      "#{train["Destination"]} #{train["Car"]} arriving in #{train["Min"]}"
    end
  end
end
