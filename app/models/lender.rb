class Lender < ActiveRecord::Base
  include LoanType
  include Residual
  include Term
  include Amortization

  enum position: [:left, :right]

  belongs_to :deal, inverse_of: :lenders
  has_many :interest_rates, dependent: :destroy
  has_many :options, dependent: :destroy

  validates :position, :bank, presence: true
  validates :position, uniqueness: { scope: :deal }
  validate :has_at_least_one_interest_rate

  accepts_nested_attributes_for :interest_rates, allow_destroy: true
  accepts_nested_attributes_for :options, allow_destroy: true

  default_scope { order(:position) }

  monetize :msrp_cents, :cash_price_cents, :trade_in_cents, :lien_cents, :cash_down_cents, :rebate_cents, :dci_cents, :bank_reg_fee_cents, :approved_maximum_cents, numericality: { greater_than_or_equal_to: 0 }

  before_validation :normalize_amortization

  def setup_options
    lender_l, lender_r = deal.lenders.order(:position)

    self.options = deal.options.map do |index|

      _term = case index
      when 1
        left? ? lender_r.term - 12 : lender_r.term
      when 2
        left? ? lender_r.term - 24 : lender_r.term
      when 3
        left? ? 36 : 96
      else
        term
      end

      _amortization = case index
      when 4
        amortization if right? && scenario == 2
      end

      _loan_type = case index
      when 1, 2, 3
        'finance' if left? && scenario == 2
      when 4
        'finance' if right? && scenario == 3
      end
      _loan_type ||= loan_type

      Option.new index: index, payment_frequency: deal.payment_frequency_max, interest_rate: interest_rate, residual_value: residual_value, residual_unit: residual_unit, term: _term, amortization: _amortization, loan_type: _loan_type
    end
  end

  def option
    options.where(index: deal.option).first
  end

  def interest_rate
    min, max = interest_rates.map(&:value).minmax
    right? ? min : max
  end

  def car_amount
    amount = cash_price - trade_in
    tax = amount * deal.vehicle_tax
    amount = amount + lien - dci - rebate - cash_down + bank_reg_fee
    finance? ? amount + tax : amount
  end

  def lender
    self
  end

  private

  def has_at_least_one_interest_rate
    if interest_rates.empty?
      errors.add(:interest_rates, 'must have at least one rate')
    end
  end

  def normalize_amortization
    self.amortization = nil unless right? && scenario == 2
    true
  end

  def scenario
    deal.scenario
  end
end
