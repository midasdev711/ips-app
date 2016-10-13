module DealsHelper

  def cross_copy(*properties)
    icon = content_tag(:i, '', class: 'fa fa-exchange')
    button_tag(icon, class: 'button tiny secondary cross-copy', data: { 'property-name' => properties.join(' ') })
  end

  def terms
    [12, 24, 36, 48, 60, 72, 84, 96]
  end

  def residual_units
    [['$', :dollar], ['%', :percent]]
  end

end
