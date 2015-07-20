class RemoveMoreDefaultsFromLenders < ActiveRecord::Migration
  def change
    change_column_default :lenders, :cash_price_cents, nil
    change_column_default :lenders, :trade_in_cents, nil
    change_column_default :lenders, :lien_cents, nil
    change_column_default :lenders, :cash_down_cents, nil
    change_column_default :lenders, :rebate_cents, nil
    change_column_default :lenders, :dci_cents, nil
    change_column_default :lenders, :residual_cents, nil
    change_column_default :lenders, :bank_reg_fee_cents, nil
  end
end
