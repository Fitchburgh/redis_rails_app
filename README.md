# Redis Spotify and Giphy API App

##Synopsis
This Rails application utilizes redis as a caching method for storage and retrieval of already searched
information.  It uses workers to improve user speeds for the requesting of Spotify API information.  The user searches for an artist and queries request information from both the
Spotify and Giphy APIs to return information on the artist, as well as their Wikipedia page.

##Code Example
The following is the worker method that requests and saves artist information from the Spotify API.  
If the user searches for an artist that exists in the API, the artist name, number of followers, artist image, and all associated genres are saved as key value pairs in Redis.  The information is then requested from Redis to display on the page.

```ruby

def perform(clean_artist)
  @data = get_json("https://api.spotify.com/v1/search?type=artist&q=#{clean_artist}")['artists']['items'][0]
  unless @data.nil?
    @name = Redis.current.set(clean_artist + ':artist', @data['name'])
    @images = Redis.current.set(clean_artist + ':image', @data['images'][0]['url'])
    @followers = Redis.current.set(clean_artist + ':followers', @data['followers']['total'])
    @genres = Redis.current.set(clean_artist + ':genres', JSON.dump(@data['genres']))
  end
end

def get_json(url)
  HTTParty.get(url).parsed_response
end

```

##Requirements
This program requires a current version of Ruby, which can be found at:

>https://www.ruby-lang.org/en/downloads/

and a current version of Rails:

>http://railsinstaller.org/en

Download the repository, run

>$ bundle install

in the terminal to download all gems in the Gemfile.  Then switch to the directory in your file system and run:

>$ rails s

to open a Rails server.  Then go to:

>localhost:3000

in the web browser and begin searching for artists.

##Contributors
Nate Semmler
