class AddDefaultZeroToMoneyColumns < ActiveRecord::Migration
  def change
    change_column_default :deals, :payment_max_cents, 0
    change_column_default :deals, :payment_min_cents, 0

    change_column_default :lenders, :msrp_cents, 0
    change_column_default :lenders, :cash_price_cents, 0
    change_column_default :lenders, :trade_in_cents, 0
    change_column_default :lenders, :lien_cents, 0
    change_column_default :lenders, :cash_down_cents, 0
    change_column_default :lenders, :rebate_cents, 0
    change_column_default :lenders, :dci_cents, 0
    change_column_default :lenders, :residual_cents, 0
    change_column_default :lenders, :approved_maximum_cents, 0
    change_column_default :lenders, :bank_reg_fee_cents, 0

    change_column_default :options, :residual_cents, 0

    change_column_default :product_lists, :car_profit_cents, 0
    change_column_default :product_lists, :family_profit_cents, 0

    change_column_default :products, :retail_price_cents, 0
    change_column_default :products, :dealer_cost_cents, 0
  end
end
