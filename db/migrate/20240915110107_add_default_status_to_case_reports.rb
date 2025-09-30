class AddDefaultStatusToCaseReports < ActiveRecord::Migration[7.1]
  def change
    change_column_default :case_reports, :status, from: nil, to: 'pending'
  end
end
