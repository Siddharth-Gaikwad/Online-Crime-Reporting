class CreateCaseReports < ActiveRecord::Migration[7.1]
  def change
    create_table :case_reports do |t|
      t.text :title
      t.text :description
      t.text :location
      t.references :branch, null: false, foreign_key: true
      t.integer :status
      t.integer :phone_no

      t.timestamps
    end
  end
end
