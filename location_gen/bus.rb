class Bus
  include Locatable

  attr_reader :name

  def initialize data_hash
    @name = data_hash["Name"]
    @lat  = data_hash["Lat"].to_f
    @long = data_hash["Lon"].to_f
    @code = data_hash["StopID"]

  end

  def self.all_stations
    key = File.read  "./location_gen/metro_api.txt"
    r = HTTParty.get(
      "https://api.wmata.com/Bus.svc/json/jStops",
      headers: { "api_key" => "#{key}" }
    )
    r["Stops"].map { |h| Bus.new(h) }

  end

  def arriving_bus
    key = File.read  "./location_gen/metro_api.txt"
    r = HTTParty.get(
      "https://api.wmata.com/NextBusService.svc/json/jPredictions?StopID=#{@code}",
      headers: { "api_key" => "#{key}"}
    )
    r["Predictions"]

  end


  def extra_detail

    arriving_bus.map do |bus|

      "#{bus["DirectionText"]}, Route #{bus["RouteID"]}, arriving in #{bus["Minutes"]} minutes"
      end
    end

  end
