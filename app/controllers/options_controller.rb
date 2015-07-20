class OptionsController < ApplicationController
  before_action :set_resources

  def show
    @client = @deal.client
    @lender_l, @lender_r = @deal.lenders
    @option_l, @option_r = [@lender_l, @lender_r].map(&:option)

    [@option_l, @option_r].map(&:calculate)

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "deal##{@deal.id}", template: 'options/show.pdf.haml', show_as_html: params[:debug].present?
      end
    end
  end

  def update
    @deal.update(deal_params)

    @lender_l, @lender_r = @deal.lenders
    @option_l, @option_r = [@lender_l, @lender_r].map(&:option)

    [@option_l, @option_r].map(&:add_misc_fees)
    [@option_l, @option_r].map(&:calculate)

    respond_to do |format|
      format.js { render partial: 'form' }
    end
  end

  private

  def set_resources
    @deal = Deal.find(params[:deal_id])
    @deal.option = params[:id].to_i

    authorize! :manage, @deal

    @products = @deal.product_list.products.visible
    @policies = @deal.product_list.insurance_policies
  end

  def deal_params
    params.require(:deal).permit(
      lenders_attributes: [
        :id,
        :rebate,
        :dci,
        :cash_down,
        :notes,
        options_attributes: [
          :id,
          :amortization,
          :term,
          :residual_value,
          :residual_unit,
          :interest_rate,
          :payment_frequency,
          :buydown_tier,
          product_ids: [],
          insurance_terms_attributes: [:id, :insurance_policy_id, :category, :term, :_destroy]
        ]
      ]
    )
  end

end
