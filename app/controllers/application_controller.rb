class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_force_logout

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end


  def check_force_logout
    if current_user && current_user.force_logout
      byebug
      current_user.update_column(:force_logout, false)
      current_user.update_column(:unique_session_id, nil)

      # redirect_to destroy_user_session_path
      # SessionsController.destroy
      sign_out current_user
      redirect_to "/"
    end
  end

  def admin?
    current_user.admin?
  end
  helper_method :admin?

  def financial_manager?
    current_user.financial_manager?
  end
  helper_method :financial_manager?

end
