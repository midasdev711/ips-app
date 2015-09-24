class ProductCategory
  attr_reader :name, :products, :products_and_fees, :insurance_terms
  attr_accessor :interest_rate, :payment, :profit

  def initialize(args = {})
    args.symbolize_keys!

    @name = args[:name]
    @products = args[:products]
    @products_and_fees = args[:products_and_fees]
    @insurance_terms = args[:insurance_terms]
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
