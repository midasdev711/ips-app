class WorksheetsController < ApplicationController
  before_action :set_resources

  def show
  end

  def update
    if @deal.update(deal_params) && @deal.set_scenario && @deal.setup_options
      @deal.worksheet_done!
      redirect_to deal_option_path(@deal, @deal.default_option)
    else
      js :show
      render :show
    end
  end

  private

  def set_resources
    @deal = Deal.find(params[:deal_id])
    authorize! :update, @deal

    @lender_l, @lender_r = @deal.lenders
  end

  def deal_params
    params.require(:deal).permit(
      {
        lenders_attributes: [
          :id,
          :bank,
          :loan_type,
          :msrp,
          :bank_reg_fee,
          :cash_price,
          :trade_in,
          :lien,
          :cash_down,
          :rebate,
          :dci,
          :term,
          :amortization,
          :residual_value,
          :residual_unit,
          :approved_maximum,
          interest_rates_attributes: [:id, :value, :_destroy, :lender_id],
        ]
      },
      :payment_min,
      :payment_frequency_min,
      :payment_max,
      :payment_frequency_max,
      :status_indian,
      :used,
      :tax,
      :province_id
    )
  end
end
