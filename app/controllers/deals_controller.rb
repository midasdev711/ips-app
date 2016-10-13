class DealsController < ApplicationController
  load_and_authorize_resource

  def index
    @deals = @deals.includes(:client)
  end

  def new
    @deal.build_client
  end

  def create
    if @deal.save
      redirect_to edit_deal_product_list_path(@deal), notice: 'Deal was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @deal.destroy
    redirect_to deals_path, notice: 'Deal was successfully deleted.'
  end

  def show
    @deal = Deal.find(params[:id])
    authorize! :manage, @deal

    path = case @deal.state
    when 'product_list'
      edit_deal_product_list_path(@deal)
    when 'worksheet'
      deal_worksheet_path(@deal)
    when 'option'
      deal_option_path(@deal, @deal.default_option)
    end

    redirect_to path
  end

  private

  def create_params
    params.require(:deal).permit(client_attributes: [:name, :email, :phone])
  end
end
