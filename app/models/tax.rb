class Tax
  attr_reader :lender

  def initialize(lender)
    @lender = lender
  end

  def total
    return zero_amount if lender.no_taxation?

    case lender.tax_type
    when 'one' then gst
    when 'two' then pst + gst
    else raise "unsupported tax type '#{lender.tax_type}'"
    end
  end

  def pst
    calculate(:pst)
  end

  def gst
    calculate(:gst)
  end

  def calculate(type)
    return zero_amount if lender.no_taxation?

    amount = calculate_taxable_amount(type)

    return zero_amount if amount.negative?

    rate = tax_rate(type)

    amount * rate
  end

  def calculate_taxable_amount(type)
    base_amount = lender.cash_price - lender.dci

    return base_amount if lender.tax_trade_in_not_allowed?(type)

    base_amount - lender.trade_in
  end

  private

  def tax_rate(type)
    lender.send(:"#{type}_rate")
  end

  def zero_amount
    Money.new(0)
  end
end
