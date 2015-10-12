require 'sinatra/base'
require 'tilt/erb'
require 'pry'

require './location_gen/train_program.rb'


class Transit < Sinatra::Base
    set :logging, true
attr_accessor :location

  get '/' do
    erb :index , locals: { location: nil, results: nil}

  end

  post '/location' do
    lat = params[:location][:latitude].to_f
    long = params[:location][:longitude].to_f
    s = Travelmodes.new(lat,long)
    r= s.create_table
   erb :index, locals: { location: nil, results: r}

  end
end

Transit.run!
