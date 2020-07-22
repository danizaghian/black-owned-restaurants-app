class Restaurant < ApplicationRecord
  def geocode_by_name
    Restaurant.all.each do |restaurant|
      if !restaurant.address
        results = Geocoder.search("#{restaurant.name}, California")
        if results.first && !restaurant.address
          restaurant.update(
            lat: results.first.coordinates[0],
            long: results.first.coordinates[1]
          )
        end
      end
    end
  end

  def geocode_by_address
    Restaurant.all.each do |restaurant|
      if !restaurant.lat || !restaurant.long
        results = Geocoder.search("#{restaurant.address}")
        if results.first
          restaurant.update(
            lat: results.first.coordinates[0],
            long: results.first.coordinates[1]
          )
        end
      end
    end
  end

  def reverse_geocode_all
    Restaurant.all.each do |restaurant|
      if restaurant.lat && restaurant.long && !restaurant.address
        results = Geocoder.search([restaurant.lat, restaurant.long])
        if results.first
          restaurant.update(
            address: results.first.address
          )
        end
      end
    end
  end

  def seed_yelp_data
    Restaurant.all.each do |restaurant|
      if !restaurant.image_url
        response = HTTP.auth("Bearer f92pUdbrUEEVj7HV5b_prLinnalo7C8bwS1L4ud1Nx_RJABEUpQMXc-vfp3YPlk9mwNSwkCFogIIsJHAWtOxAp9Hrl1Hd6wEMg42ICSkn3JoH21lGScTayIAqcwXX3Yx").get("https://api.yelp.com/v3/businesses/search?term=#{restaurant.name.gsub(' ', '%20')}&location=#{restaurant.location.gsub(' ', '%20')}")
        if response.parse["businesses"].length >= 1
          yelp_body = response.parse["businesses"][0]
          if yelp_body  
            restaurant.update(image_url: yelp_body["image_url"])
            if !restaurant.address
              restaurant.update(lat: yelp_body["coordinates"]["latitude"], long: yelp_body["coordinates"]["longitude"])
            end
          end
        end
      end
    end
  end
end
