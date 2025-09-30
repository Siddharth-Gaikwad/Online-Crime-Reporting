require "test_helper"

class CaseReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @case_report = case_reports(:one)
  end

  test "should get index" do
    get case_reports_url
    assert_response :success
  end

  test "should get new" do
    get new_case_report_url
    assert_response :success
  end

  test "should create case_report" do
    assert_difference("CaseReport.count") do
      post case_reports_url, params: { case_report: { branch_id: @case_report.branch_id, description: @case_report.description, location: @case_report.location, phone_no: @case_report.phone_no, status: @case_report.status, title: @case_report.title } }
    end

    assert_redirected_to case_report_url(CaseReport.last)
  end

  test "should show case_report" do
    get case_report_url(@case_report)
    assert_response :success
  end

  test "should get edit" do
    get edit_case_report_url(@case_report)
    assert_response :success
  end

  test "should update case_report" do
    patch case_report_url(@case_report), params: { case_report: { branch_id: @case_report.branch_id, description: @case_report.description, location: @case_report.location, phone_no: @case_report.phone_no, status: @case_report.status, title: @case_report.title } }
    assert_redirected_to case_report_url(@case_report)
  end

  test "should destroy case_report" do
    assert_difference("CaseReport.count", -1) do
      delete case_report_url(@case_report)
    end

    assert_redirected_to case_reports_url
  end
end
