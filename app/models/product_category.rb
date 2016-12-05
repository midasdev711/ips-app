class ProductCategory
  attr_reader :name, :product_list, :lender

  attr_accessor :interest_rate, :payment

  def initialize(name:, product_list:, lender:)
    @name, @product_list, @lender = name, product_list, lender
  end

  def display_name
    case name
    when 'pocketbook' then 'Pocketbook Protection'
    when 'car'        then 'Car Protection Kit'
    when 'family'     then 'Family Protection'
    end
  end

  def amount
    products_amount + insurance_amount
  end

  def profit
    products_profit + insurance_profit
  end

  def buy_down_amount
    profit - reserved_profit
  end

  def count
    products.count + insurance_terms.count
  end

  def available_count
    available_products.count + available_insurance_policies_count
  end

  def unselected_count
    available_count - count
  end

  def products
    lender.products.where category: name
  end

  def available_products
    product_list.products.visible.where category: name
  end

  def insurance_terms
    lender.insurance_terms.where category: name
  end

  def available_insurance_policies
    product_list.insurance_policies.includes(:insurance_rates).where('category' => name, 'insurance_rates.loan' => lender.loan).references(:insurance_rates)
  end

private

  def reserved_profit
    case name
    when 'pocketbook'
      Money.new(1_000_00) * lender.tier
    when 'car'
      product_list.car_reserved_profit
    when 'family'
      product_list.family_reserved_profit
    end
  end

  def products_amount
    products.amount + invisible_products.amount
  end

  def products_profit
    products.profit + invisible_products.profit
  end

  def insurance_amount
    insurance_terms.amount lender.insurable_amount
  end

  def insurance_profit
    insurance_amount * product_list.insurance_profit_rate
  end

  def invisible_products
    lender.invisible_products.where category: name
  end

  def available_insurance_policies_count
    available_insurance_policies.count
  end
end
