class Restaurant < ApplicationRecord
  def geocode_all
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
end
