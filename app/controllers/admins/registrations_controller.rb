# frozen_string_literal: true

class Admins::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  # Permit admin_id for signup
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:admin_id])
  end

  # Permit admin_id for account update
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:admin_id])
  end
end
