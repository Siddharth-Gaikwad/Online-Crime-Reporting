class AddBranchIdToPolice < ActiveRecord::Migration[7.1]
  def change
    add_column :police, :branch_id, :integer
  end
end
