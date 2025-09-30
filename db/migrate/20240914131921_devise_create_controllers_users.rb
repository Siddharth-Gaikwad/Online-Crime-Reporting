class DeviseCreateControllersUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :controllers_users do |t|
      t.string :email, null: false, default: ""
      t.string :reset_password_token
      # Add other fields as necessary

      t.timestamps
    end

    add_index :controllers_users, :email, unique: true
    add_index :controllers_users, :reset_password_token, unique: true
    # Add other indexes as necessary
  end
end
