class RemoveDefaultZeroFromOptionsAmortization < ActiveRecord::Migration
  def change
    change_column_default :options, :amortization, nil
  end
end
