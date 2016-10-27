# Redis Spotify and Giphy API App

##Synopsis
This Rails application utilizes redis as a caching method for storage and retrieval of already searched
information.  The user simply searches for an artist and queries request information from both the
Spotify and Giphy APIs to return information on the artist.

##Code Example
The following is the save method in the artists model.  The save method is called within the load
method to allow redis to save already searched information for future reference.  The information
is saved as key-value pairs with values being instance variables defined in the load method.

```ruby

def save
  redis = Redis.new

  clean_artist = @artist.downcase.gsub(/\s+/, "+")

  redis.set(clean_artist + ':artist', @name)

  redis.set(clean_artist + ':followers', @followers)

  redis.set(clean_artist + ':genres', JSON.dump(@genres))

  redis.set(clean_artist + ':gifs', JSON.dump(@gifs))

  redis.set(clean_artist + ':image', @image)
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

>localhost:3000/artists/guess

in the web browser.

##Contributors
Nate Semmler
