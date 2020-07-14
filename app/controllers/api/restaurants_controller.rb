class Api::RestaurantsController < ApplicationController
  
  def index
    @restaurants = Restaurant.all
    render "index.json.jb"
  end
end
