class AddLatitudeAndLongitudeToBranches < ActiveRecord::Migration[7.1]
  def change
    add_column :branches, :latitude, :float
    add_column :branches, :longitude, :float
  end
end
