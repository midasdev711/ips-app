module Taxable
  def no_taxation?
    status_indian or tax == 'no'
  end

  def tax_rate
    return 0.0 if no_taxation?

    case tax
    when 'one' then province.gst
    when 'two' then province.gst + province.pst
    end
  end
end
