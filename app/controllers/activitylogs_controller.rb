class ActivitylogsController < ApplicationController
  before_filter :authorize_admin, only: :index
  def index
    @listable = User.where("unique_session_id IS NOT ? AND force_logout = ?", nil, false)
  end

  def force_logout
    p "------------- force_logout ------------"
    admin = User.find(params[:id])
    admin.update_column(:force_logout, true)
    redirect_to activitylogs_path
  end

  private

  # This should probably be abstracted to ApplicationController
  # as shown by diego.greyrobot
  def authorize_admin
    return unless !current_user.admin?
    redirect_to root_path, alert: 'Admins only!'
  end
end
