class ProductCategory
  attr_reader :name, :products, :products_and_fees, :insurance_terms, :count, :available_count

  attr_accessor :interest_rate, :payment

  attr_accessor :cost_of_borrowing

  attr_accessor :buydown_amount, :kickback_amount

  def initialize(name:, products:, products_and_fees:, insurance_terms:, count:, available_count:, insurable_value:, insurance_profit:)
    @name, @products, @products_and_fees, @insurance_terms, @count, @available_count, @insurable_value, @insurance_profit = name, products, products_and_fees, insurance_terms, count, available_count, insurable_value, insurance_profit
    @buydown_amount, @kickback_amount = Money.new(0), Money.new(0)
  end

  def amount
    products_amount = @products_and_fees.reduce(Money.new(0)) { |sum, p| sum + p.price }
    products_amount + insurance_amount
  end

  def profit
    products_profit = @products_and_fees.reduce(Money.new(0)) { |sum, p| sum + p.profit }
    products_profit + insurance_amount * @insurance_profit
  end

  def full_name
    case name
    when 'pocketbook' then 'Pocketbook Protection'
    when 'car' then 'Car Protection Kit'
    when 'family' then 'Family Protection'
    else
      name
    end
  end

private

  def insurance_amount
    @insurance_terms.premium @insurable_value
  end
end
