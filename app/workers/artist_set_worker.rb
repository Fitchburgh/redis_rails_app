require 'redis'
require 'sidekiq'
require 'httparty'
require 'json'
require 'pry'

class ArtistSetWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false
  def perform(clean_artist)
    @data = get_json("https://api.spotify.com/v1/search?type=artist&q=#{clean_artist}")['artists']['items'][0]
    unless @data.nil?
      @name = REDIS.set(clean_artist + ':artist', @data['name'])
      @images = REDIS.set(clean_artist + ':image', @data['images'][0]['url'])
      @followers = REDIS.set(clean_artist + ':followers', @data['followers']['total'])
      @genres = REDIS.set(clean_artist + ':genres', JSON.dump(@data['genres']))
    end
  end

  def get_json(url)
    HTTParty.get(url).parsed_response
  end
end
