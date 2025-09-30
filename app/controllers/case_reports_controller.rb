class CaseReportsController < ApplicationController
  before_action :set_case_report, only: %i[show edit update destroy]
  
  # Authenticate users and police for specific actions
  before_action :authenticate_user_or_police_or_admin!, only: [:index, :show]

  # Separate before_action for user-only actions
  before_action :authenticate_user!, only: [:create]

  # Separate before_action for police-only actions
  before_action :authenticate_police!, only: [:edit, :update]

  # GET /case_reports or /case_reports.json
  def index
    if user_signed_in?
      @case_reports = CaseReport.where(user_id: current_user.id)
    elsif police_signed_in?
      @case_reports = CaseReport.where(branch_id: current_police.branch_id)
    elsif admin_signed_in?
      @case_reports = CaseReport.all
    else
      redirect_to new_user_session_path, alert: "Please sign in to view case reports."
    end
  end

  def solved
    @solved_cases = CaseReport.where(branch_id: current_police.branch_id, status: "Solved")
  end

  def pending
    @pending_cases = CaseReport.where(branch_id: current_police.branch_id, status: "pending")
  end

  # GET /case_reports/1 or /case_reports/1.json
  def show
    @case_report = CaseReport.find(params[:id])
    
    if user_signed_in? && @case_report.user_id == current_user.id
      # Users can view their own cases
    elsif police_signed_in? && @case_report.branch_id == current_police.branch_id
      # Police can view cases in their branch
    elsif admin_signed_in?
      # Admin can view any case report
    else
      redirect_to root_path, alert: "Not authorized to view this case."
    end
  end

  # GET /case_reports/new
  def new
    @case_report = CaseReport.new
    @branches = Branch.all
  end

  # GET /case_reports/1/edit
  def edit
    @case_report = CaseReport.find(params[:id])
    @branches = Branch.all

    if police_signed_in? && @case_report.branch_id == current_police.branch_id
      # Allow police to edit cases in their branch
    elsif user_signed_in? && @case_report.user_id == current_user.id
      # Allow users to edit their own cases
    else
      redirect_to root_path, alert: "Not authorized to edit this case."
    end
  end

  # POST /case_reports or /case_reports.json
  def create
    @case_report = CaseReport.new(case_report_params)
    @case_report.status = "pending"
    @case_report.user_id = current_user.id  # Associate the case report with the current user

    # Auto-assign nearest branch based on location
    if @case_report.location.present?
      lat, lng = @case_report.location.split(',').map(&:strip).map(&:to_f)
      nearest_branch = Branch.nearest_branch(lat, lng)
      @case_report.branch = nearest_branch if nearest_branch.present?
    end

    respond_to do |format|
      if @case_report.save
        format.html { redirect_to case_reports_url(@case_report), notice: "Case report was successfully created." }
        format.json { render :show, status: :created, location: @case_report }
      else
        @branches = Branch.all  # Ensure branches are available if render :new
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @case_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /case_reports/1 or /case_reports/1.json
  def update
    @case_report = CaseReport.find(params[:id])
    
    if police_signed_in? && @case_report.branch_id == current_police.branch_id
      # Police can only update the status of cases in their branch
      if @case_report.update(police_case_report_params)
        redirect_to @case_report, notice: "Case report status successfully updated."
      else
        render :edit
      end
    elsif user_signed_in? && @case_report.user_id == current_user.id
      # Users can update their own cases except the branch and status
      if @case_report.update(case_report_params)
        redirect_to @case_report, notice: "Case report successfully updated."
      else
        render :edit
      end
    else
      redirect_to root_path, alert: "Not authorized to update this case."
    end
  end

  # Strong parameters for police (only status is permitted)
  def police_case_report_params
    params.require(:case_report).permit(:status)
  end

  # DELETE /case_reports/1 or /case_reports/1.json
  def destroy
    @case_report.destroy

    respond_to do |format|
      format.html { redirect_to case_reports_url, notice: "Case report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_case_report
      @case_report = CaseReport.find(params[:id])
    end

    def authenticate_user_or_police_or_admin!
      if user_signed_in?
        authenticate_user!
      elsif police_signed_in?
        authenticate_police!
      elsif admin_signed_in?
        authenticate_admin!
      else
        redirect_to new_user_session_path, alert: "Please sign in."
      end
    end

    # Only allow a list of trusted parameters through.
    def case_report_params
      # Note: No branch_id here since it is auto-assigned based on location
      params.require(:case_report).permit(:title, :description, :phone_no, :location, :latitude, :longitude, :branch_id)
    end
end

