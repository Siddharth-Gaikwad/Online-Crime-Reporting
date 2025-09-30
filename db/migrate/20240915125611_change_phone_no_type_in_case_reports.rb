class ChangePhoneNoTypeInCaseReports < ActiveRecord::Migration[7.1]
  def change
    change_column :case_reports, :phone_no, :string
  end
end
