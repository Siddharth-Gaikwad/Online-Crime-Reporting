class AddUserIdToCaseReports < ActiveRecord::Migration[7.1]
  def change
    add_column :case_reports, :user_id, :integer
    add_foreign_key :case_reports, :users  # If you have a users table
    add_index :case_reports, :user_id 
  end
end
