class UsersController < ApplicationController
  before_action :set_dealership
  load_and_authorize_resource

  def index
    @users = @users.where dealership: @dealership
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @user = @dealership.users.build(user_params)
    if @user.save
      @user.send_reset_password_instructions if @user.financial_manager?
      redirect_to dealership_users_path(@dealership), notice: 'User has been successfully created.'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to dealership_users_path(@dealership), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to dealership_users_path(@dealership), notice: 'User was successfully deleted.'
  end

  private

  def set_dealership
    @dealership = Dealership.find(params[:dealership_id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
