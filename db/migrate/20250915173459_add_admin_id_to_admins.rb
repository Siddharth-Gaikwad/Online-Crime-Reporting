class AddAdminIdToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :admin_id, :string
    add_index :admins, :admin_id, unique: true
  end
end
