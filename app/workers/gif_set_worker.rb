require 'redis'
require 'sidekiq'
require 'httparty'

class GifSetWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false
  def perform(clean_artist)
    @gif_data = get_json("http://api.giphy.com/v1/gifs/search?q=#{clean_artist}&api_key=dc6zaTOxFJmzC")['data']

    gifs = [
      @gif_data[0]['embed_url'],
      @gif_data[1]['embed_url'],
      @gif_data[2]['embed_url'],
      @gif_data[3]['embed_url']
    ]

    @gifs = Redis.current.set(clean_artist + ':gifs', JSON.dump(gifs))
  end

  def get_json(url)
    HTTParty.get(url).parsed_response
  end
end
