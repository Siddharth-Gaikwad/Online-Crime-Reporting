class AddPoliceIdToPolice < ActiveRecord::Migration[6.0]
  def change
    add_column :police, :police_id, :string
    add_index :police, :police_id, unique: true
  end
end
