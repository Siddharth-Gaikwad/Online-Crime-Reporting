class CreateBranches < ActiveRecord::Migration[7.1]
  def change
    create_table :branches do |t|
      t.string :name
      t.text :address
      t.text :city
      t.text :state
      t.integer :pincode

      t.timestamps
    end
  end
end
