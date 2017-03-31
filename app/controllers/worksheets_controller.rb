class WorksheetsController < ApplicationController
  before_action :set_resources

  def show
  end

  def update
    if @deal.update update_params
      @deal.worksheet_done!
      [@lender_l, @lender_r].map &:reset!
      redirect_to @deal
    else
      js :show
      render :show
    end
  end

  private

  def set_resources
    @deal = Deal.find params[:deal_id]
    authorize! :update, @deal

    @client = @deal.client

    @lender_l, @lender_r = @deal.lenders
    @interest_rates_l, @interest_rates_r = [@lender_l, @lender_r].map &:interest_rates
    @new_interest_rate_l, @new_interest_rate_r = InterestRate.new(lender: @lender_l), InterestRate.new(lender: @lender_r)
  end

  def update_params
    params.require(:deal).permit(
      :province_id,

      :max_frequency,
      :max_payment,
      :min_frequency,
      :min_payment,
      :status_indian,
      :pst_trade_in_allowance,
      :gst_trade_in_allowance,
      :tax,
      :used,

      lenders_attributes: [
        :id,

        :amortization,
        :bank,
        :bank_reg_fee,
        :cash_down,
        :cash_price,
        :dci,
        :frequency,
        :kickback_percent,
        :lien,
        :loan,
        :max_amount,
        :msrp,
        :rebate,
        :residual_value,
        :residual_unit,
        :rounding,
        :term,
        :trade_in,

        interest_rates_attributes: [
          :id,
          :lender_id,

          :percent_value,

          :_destroy
        ]
      ]
    )
  end
end
