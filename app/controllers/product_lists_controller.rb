class ProductListsController < ApplicationController
  before_action :set_product_list, only: [:edit, :update]
  before_action :clone_insurance_policies, only: :update, if: :financial_manager?

  def edit
  end

  def update
    if @product_list.update(product_list_params)
      @listable.product_list_done! if @listable.is_a?(Deal)
      redirect_to redirect_path, notice: 'Product List was successfully updated.'
    else
      js :edit
      render :edit
    end
  end

  private

  def set_product_list
    @listable = Dealership.find(params[:dealership_id]) if params[:dealership_id].present?
    @listable = Deal.find(params[:deal_id])             if params[:deal_id].present?
    @product_list = (@listable || current_user).product_list
    authorize! :update, @product_list
  end

  def product_list_params
    if admin?
      insurance_policies_attributes = [
        :id, :name, :category, :loan_type, :residual, :_destroy,
        insurance_rates_attributes: [:id, :term, :value]
      ]
    end

    if financial_manager?
      insurance_policies_attributes = [
        :id, :prototype_id, :category, :_destroy
      ]
    end

    params.require(:product_list).permit(
      :car_profit,
      :family_profit,
      :insurance_profit,
      products_attributes: [
        :id,
        :name,
        :tax,
        :retail_price,
        :dealer_cost,
        :category,
        :_destroy
      ],
      insurance_policies_attributes: insurance_policies_attributes,
      deal_attributes: [:id, :province_id]
    )
  end

  def clone_insurance_policies
    clones = product_list_params[:insurance_policies_attributes].reduce([]) do |acc, (index, attrs)|
      params[:product_list][:insurance_policies_attributes].delete(index) if attrs[:id].nil?
      acc << attrs if attrs[:prototype_id].present? && attrs[:_destroy] == 'false'
      acc
    end

    dealership_policies = current_user.dealership.product_list.insurance_policies

    clones.each do |attrs|
      prototype = dealership_policies.find(attrs[:prototype_id])
      clone = prototype.deep_clone(include: :insurance_rates)
      clone.category = attrs[:category]
      @product_list.insurance_policies << clone
    end
  end

  def redirect_path
    case @listable.class.to_s
    when 'Dealership'
      dealerships_path
    when 'Deal'
      deal_path(@listable)
    else
      deals_path
    end
  end
end
