class DealsController < ApplicationController
  # load_and_authorize_resource

  before_action :normalize_insurance_terms_params, only: :update

  def index
    @deals = Deal.includes(:client)
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

  def show
    case @deal.state
    when 'product_list'
      return redirect_to edit_deal_product_list_path @deal
    when 'worksheet'
      return redirect_to deal_worksheet_path @deal
    end

    @client = @deal.client
    @lender_l, @lender_r = @deal.lenders

    @interest_rates_l, @interest_rates_r = [@lender_l, @lender_r].map &:interest_rates

    @lender_l.calculate!
    @lender_l.warnings?

    @lender_r.calculate!
    @lender_r.warnings?

    @max_tier = @lender_r.max_tier
    @tier = @lender_r.tier

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "deal##{@deal.id}", template: 'deals/show.pdf.haml', show_as_html: params[:debug].present?
      end
    end
  end

  def update
    @deal.update! update_params

    @lender_l, @lender_r = @deal.lenders

    @interest_rates_l, @interest_rates_r = [@lender_l, @lender_r].map &:interest_rates

    @lender_l.calculate!
    @lender_l.warnings?

    @lender_r.calculate!
    @lender_r.warnings?

    @max_tier = @lender_r.max_tier
    @tier = @lender_r.tier

    respond_to do |format|
      format.js { render partial: 'form' }
    end
  end

  def destroy
    @deal.destroy
    redirect_to deals_path, notice: 'Deal was successfully deleted.'
  end

  private

  def create_params
    params.require(:deal).permit(
      client_attributes: [
        :name,
        :email,
        :phone
      ]
    )
  end

  def update_params
    params.require(:deal).permit(
      lenders_attributes: [
        :id,
        :interest_rate_id,
        :residual_value,
        :residual_unit,
        :amortization,
        :cash_down,
        :dci,
        :frequency,
        :notes,
        :rebate,
        :term,
        :tier,

        product_ids: [],

        insurance_terms_attributes: [
          :id,
          :insurance_policy_id,

          :category,
          :overridden,
          :premium,
          :term,
          :residual,

          :_destroy
        ]
      ]
    )
  end

  def normalize_insurance_terms_params
    lenders_attributes = params[:deal][:lenders_attributes]

    lender_l_attributes = lenders_attributes['0']
    lender_r_attributes = lenders_attributes['1']

    lender_l_insurance_terms_attributes = lenders_attributes['6'][:insurance_terms_attributes]
    lender_r_insurance_terms_attributes = lenders_attributes['7'][:insurance_terms_attributes]

    if lender_l_insurance_terms_attributes
      lender_l_insurance_terms_attributes.each do |_, insurance_term_attributes|
        if insurance_term_attributes[:term] > lender_l_attributes[:term]
          insurance_term_attributes[:term] = lender_l_attributes[:term]
        end
      end
    end

    if lender_r_insurance_terms_attributes
      lender_r_insurance_terms_attributes.each do |_, insurance_term_attributes|
        if insurance_term_attributes[:term] > lender_r_attributes[:term]
          insurance_term_attributes[:term] = lender_r_attributes[:term]
        end
      end
    end
  end
end
