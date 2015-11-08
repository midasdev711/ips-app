class RemoveDefaultZeroFromLendersAmortization < ActiveRecord::Migration
  def change
    change_column_default :lenders, :amortization, nil
  end
end
