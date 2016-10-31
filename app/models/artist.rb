require 'redis'
require 'sidekiq'
require_relative '../workers/artist_set_worker.rb'
require_relative '../workers/gif_set_worker.rb'
require 'pry'

class Artist
  attr_reader :artist, :name, :followers, :genres, :gifs, :image

  def initialize(artist)
    @artist = artist
    load
  end

  def load
    @clean_artist = @artist.downcase.gsub(/\s+/, "+")

    if not_have_artist
      search_and_save_artist
    else
      find_artist
    end
  end

  def not_have_artist
    Redis.current.get(@clean_artist + ':artist').nil?
  end

  def find_artist
    @name = Redis.current.get(@clean_artist + ':artist')
    @image = Redis.current.get(@clean_artist + ':image')
    @followers = Redis.current.get(@clean_artist + ':followers')
    if !Redis.current.get(@clean_artist + ':genres').nil?
      @genres = JSON.parse(Redis.current.get(@clean_artist + ':genres'))
      if !Redis.current.get(@clean_artist + ':gifs').nil?
        @gifs = JSON.parse(Redis.current.get(@clean_artist + ':gifs'))
      end
    end
  end

  def search_and_save_artist
    if @clean_artist.length >= 2
      ArtistSetWorker.perform_async(@clean_artist)
      GifSetWorker.perform_async(@clean_artist)
      sleep(1.25)
      find_artist
    end
  end

  def get_json(url)
    HTTParty.get(url).parsed_response
  end
end

# artist = Artist.new('silversun+pickups')
# artist.load
# ArtistWorker.perform_async(@artist)
