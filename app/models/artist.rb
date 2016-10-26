class Artist
  attr_reader :artist, :name, :followers, :genres, :gifs, :image

  def initialize(artist)
    @artist = artist

    load
  end

  def load
    redis = Redis.new

    clean_artist = @artist.downcase.gsub(/\s+/, "+")

    if redis.get(clean_artist + ':artist').nil?
      data = get_json("https://api.spotify.com/v1/search?type=artist&q=#{clean_artist}")['artists']['items'][0]
      @name = data['name']
      @followers = data['followers']['total']
      @genres = data['genres']

      gif_data = get_json("http://api.giphy.com/v1/gifs/search?q=#{clean_artist}&api_key=dc6zaTOxFJmzC")['data']
      @gifs = [
        gif_data[0]['embed_url'],
        gif_data[1]['embed_url'],
        gif_data[2]['embed_url'],
        gif_data[3]['embed_url']
      ]

      @image = data['images'][0]['url']

      save
    else
      @name = redis.get(clean_artist + ':artist')
      @followers = redis.get(clean_artist + ':followers')
      @genres = JSON.parse(redis.get(clean_artist + ':genres'))
      @gifs = JSON.parse(redis.get(clean_artist + ':gifs'))
      @image = redis.get(clean_artist + ':image')
    end
  end

  def save
    redis = Redis.new

    clean_artist = @artist.downcase.gsub(/\s+/, "+")

    redis.set(clean_artist + ':artist', @name)

    redis.set(clean_artist + ':followers', @followers)

    redis.set(clean_artist + ':genres', JSON.dump(@genres))

    redis.set(clean_artist + ':gifs', JSON.dump(@gifs))

    redis.set(clean_artist + ':image', @image)
  end

  def get_json(url)
    HTTParty.get(url).parsed_response
  end
end
