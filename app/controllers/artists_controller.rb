require 'redis'

class ArtistsController < ApplicationController
  def guess
  end

  def return
    @artist = Artist.new(params['artist']['artist'])
  end

  def show
    render :guess
  end
end
