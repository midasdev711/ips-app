class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
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
