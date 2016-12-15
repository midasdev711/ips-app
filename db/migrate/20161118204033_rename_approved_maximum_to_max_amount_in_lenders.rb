class RenameApprovedMaximumToMaxAmountInLenders < ActiveRecord::Migration[5.0]
  def change
    rename_column :lenders, :approved_maximum_cents, :max_amount_cents
  end
end
