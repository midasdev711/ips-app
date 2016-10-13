class DealershipsController < ApplicationController
  load_and_authorize_resource

  def index
    @dealerships = @dealerships.includes(:principal)
  end

  def new
    @dealership.status = :inactive
    @dealership.build_principal
  end

  def create
    @dealership = current_user.add_dealership resource_params
    if @dealership.persisted?
      redirect_to root_path, notice: 'Dealership was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @dealership.update resource_params
      redirect_to dealerships_path, notice: 'Dealership was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @dealership.destroy
    redirect_to dealerships_path, notice: 'Dealership was successfully deleted.'
  end

  private

  def resource_params
      params.require(:dealership).permit(
        :name, :address, :province_id, :phone, :status,
        principal_attributes: [:id, :name, :phone, :email]
      )
    end
end
