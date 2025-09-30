json.extract! case_report, :id, :title, :description, :location, :branch_id, :status, :phone_no, :created_at, :updated_at
json.url case_report_url(case_report, format: :json)
