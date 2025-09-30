class AddDateDataToCaseReport < ActiveRecord::Migration[7.1]
  def change
    add_column :case_reports, :Timestmp, :datetime
  end
end
