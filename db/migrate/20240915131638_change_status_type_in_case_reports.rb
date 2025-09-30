class ChangeStatusTypeInCaseReports < ActiveRecord::Migration[7.1]
  def change
    change_column :case_reports, :status, :string
  end
end
