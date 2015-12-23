class ProductCategory
  attr_reader :name, :products, :products_and_fees, :insurance_terms
  attr_accessor :interest_rate, :payment, :profit

  def initialize(name:, products:, products_and_fees:, insurance_terms:)
    @name, @products, @products_and_fees, @insurance_terms = name, products, products_and_fees, insurance_terms
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

  def count
    @products.count + @insurance_terms.count
  end
end
