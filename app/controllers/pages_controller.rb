class PagesController < ApplicationController
  before_action :authenticate_user!,only: [:users]
  before_action :authenticate_admin!,only: [:admin]
  before_action :authenticate_police!,only: [:police]
  def home
  end

  def users
  end

  def admin
  end

  def police
    if police_signed_in?
      @case_reports = CaseReport.all 
    end
    
  end
end
