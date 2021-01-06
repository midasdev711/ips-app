class ActivitylogsController < ApplicationController
  before_filter :authorize_admin, only: :index
  def index
    @listable = LoginActivity.where(success: 'true')
  end

  private

  # This should probably be abstracted to ApplicationController
  # as shown by diego.greyrobot
  def authorize_admin
    return unless !current_user.admin?
    redirect_to root_path, alert: 'Admins only!'
  end
end
