module ApplicationHelper

  def taxes
    [['One Tax', :one], ['Two Tax', :two], ['No Tax', :no]]
  end

  def product_categories
    Product.categories.map { |k, _| [full_category_name(k), k] }
  end

  def loan_types
    Lender.loan_types.map { |k, v| [k.capitalize, k] }
  end

  def payment_frequencies
    Deal::PAYMENT_FREQUENCIES
  end

  def formalize_entity_name(name)
    name.downcase.gsub(' ', '-')
  end

  def provinces
    Settings.provinces
  end

  def provinces_with_taxes
    provinces.map { |p| [p.abbr, { 'data-pst' => p.pst, 'data-gst' => p.gst }] }
  end

  def autonumeric_options
    { 'aPad' => 'false', 'wEmpty' => 'zero', 'lZer' => 'deny' }
  end

  def full_category_name(category)
     if category.to_s.downcase == 'car'
      'Car Protection Kit'
    else
      "#{category.to_s.downcase.capitalize} Protection"
    end
  end
end
