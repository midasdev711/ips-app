class ProductCategory
  attr_reader :name, :products, :products_and_fees, :insurance_terms, :count, :available_count
  attr_accessor :interest_rate, :payment, :profit

  attr_accessor :amount, :buydown_amount # for debugging

  def initialize(name:, products:, products_and_fees:, insurance_terms:, count:, available_count:)
    @name, @products, @products_and_fees, @insurance_terms, @count, @available_count = name, products, products_and_fees, insurance_terms, count, available_count
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
end
