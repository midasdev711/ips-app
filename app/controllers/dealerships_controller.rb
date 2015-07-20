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
    @dealership = Dealership.new(dealership_params)
    if @dealership.save
      redirect_to root_path, notice: 'Dealership was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @dealership.update(dealership_params)
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

  def dealership_params
      params.require(:dealership).permit(
        :name, :address, :province_id, :phone, :status,
        principal_attributes: [:id, :name, :phone, :email]
      )
    end
end
