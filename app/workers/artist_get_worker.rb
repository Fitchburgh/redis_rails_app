require 'redis'
require 'sidekiq'
require 'json'

class ArtistGetWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false
  def perform(clean_artist)
    @name = Redis.current.get(@clean_artist + ':artist')
    @image = Redis.current.get(@clean_artist + ':image')
    @followers = Redis.current.get(@clean_artist + ':followers')
    @genres = JSON.parse(Redis.current.get(@clean_artist + ':genres'))
    @gifs = JSON.parse(Redis.current.get(@clean_artist + ':gifs'))
  end
end
