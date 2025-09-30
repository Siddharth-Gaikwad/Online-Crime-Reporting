class AddLatitudeAndLongitudeToCaseReports < ActiveRecord::Migration[7.1]
  def change
    add_column :case_reports, :latitude, :float
    add_column :case_reports, :longitude, :float
  end
end
