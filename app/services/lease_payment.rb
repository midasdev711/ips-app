class LeasePayment
  class << self
    def execute(amount, residual, number_of_payments, money_factor)
      depreciation_fee = (amount - residual) / number_of_payments
      finance_fee = (amount + residual) * money_factor
      (depreciation_fee + finance_fee).round
    end
  end
end
