class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :location
      t.string :cuisine
      t.string :service
      t.string :instagram
      t.string :phone
      t.string :website
      t.string :other
      t.float :long
      t.float :lat
      t.string :address

      t.timestamps
    end
  end
end
