class Artist
  attr_reader :artist, :name, :followers, :genres, :gifs, :image

  def initialize(artist)
    @artist = artist

    load
  end

  def load
    redis = Redis.new

    clean_artist = @artist.downcase.gsub(/\s+/, "+")

    if not_have_artist(clean_artist, redis)
      search_and_save_artist(clean_artist, redis)
    else
      find_artist(clean_artist, redis)
    end
  end

  def not_have_artist(clean_artist, redis)
    redis.get(clean_artist + ':artist').nil?
  end

  def find_artist(clean_artist, redis)
    @name = redis.get(clean_artist + ':artist')
    @image = redis.get(clean_artist + ':image')
    @followers = redis.get(clean_artist + ':followers')
    @genres = JSON.parse(redis.get(clean_artist + ':genres'))
    @gifs = JSON.parse(redis.get(clean_artist + ':gifs'))
  end

  def search_and_save_artist(clean_artist, redis)
    if clean_artist.length >= 2
      data = get_json("https://api.spotify.com/v1/search?type=artist&q=#{clean_artist}")['artists']['items'][0]
      if !data.nil?
        retrieve_api_information(clean_artist, redis, data)
      end
    end
  end

  def retrieve_api_information(clean_artist, redis, data)
    @name = data['name']
    @image = data['images'][0]['url']
    @followers = data['followers']['total']
    @genres = data['genres']

    gif_data = get_json("http://api.giphy.com/v1/gifs/search?q=#{clean_artist}&api_key=dc6zaTOxFJmzC")['data']
    @gifs = [
      gif_data[0]['embed_url'],
      gif_data[1]['embed_url'],
      gif_data[2]['embed_url'],
      gif_data[3]['embed_url']
    ]

    save(redis)
  end

  def save(redis)
    clean_artist = @artist.downcase.gsub(/\s+/, "+")

    redis.set(clean_artist + ':artist', @name)
    redis.set(clean_artist + ':image', @image)
    redis.set(clean_artist + ':followers', @followers)
    redis.set(clean_artist + ':genres', JSON.dump(@genres))
    redis.set(clean_artist + ':gifs', JSON.dump(@gifs))
  end

  def get_json(url)
    HTTParty.get(url).parsed_response
  end
end
