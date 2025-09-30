require "application_system_test_case"

class CaseReportsTest < ApplicationSystemTestCase
  setup do
    @case_report = case_reports(:one)
  end

  test "visiting the index" do
    visit case_reports_url
    assert_selector "h1", text: "Case reports"
  end

  test "should create case report" do
    visit case_reports_url
    click_on "New case report"

    fill_in "Branch", with: @case_report.branch_id
    fill_in "Description", with: @case_report.description
    fill_in "Location", with: @case_report.location
    fill_in "Phone no", with: @case_report.phone_no
    fill_in "Status", with: @case_report.status
    fill_in "Title", with: @case_report.title
    click_on "Create Case report"

    assert_text "Case report was successfully created"
    click_on "Back"
  end

  test "should update Case report" do
    visit case_report_url(@case_report)
    click_on "Edit this case report", match: :first

    fill_in "Branch", with: @case_report.branch_id
    fill_in "Description", with: @case_report.description
    fill_in "Location", with: @case_report.location
    fill_in "Phone no", with: @case_report.phone_no
    fill_in "Status", with: @case_report.status
    fill_in "Title", with: @case_report.title
    click_on "Update Case report"

    assert_text "Case report was successfully updated"
    click_on "Back"
  end

  test "should destroy Case report" do
    visit case_report_url(@case_report)
    click_on "Destroy this case report", match: :first

    assert_text "Case report was successfully destroyed"
  end
end
