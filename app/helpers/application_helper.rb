module ApplicationHelper

  def autonumeric_options
    # { 'aPad' => 'false', 'wEmpty' => 'zero', 'lZer' => 'deny' }
    { 'aPad' => 'false', 'lZer' => 'deny' }
  end

  def compounding_frequencies
    Deal::COMPOUNDING_FREQUENCIES
  end

  def cross_copy(*properties)
    icon = content_tag(:i, '', class: 'fa fa-exchange')
    button_tag(icon, class: 'button tiny secondary cross-copy', data: { 'property-name' => properties.join(' ') })
  end

  def loans
    Lender.loans.map { |k, v| [k.capitalize, k] }
  end

  def provinces
    Settings.provinces
  end

  def provinces_with_taxes
    provinces.map { |p| [p.abbr, { 'data-pst' => p.pst, 'data-gst' => p.gst }] }
  end

  def residual_units
    [['$', :dollar], ['%', :percent]]
  end

  def taxes
    [['One Tax', :one], ['Two Tax', :two], ['No Tax', :no]]
  end
end
