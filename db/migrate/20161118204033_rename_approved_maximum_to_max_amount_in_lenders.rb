class RenameApprovedMaximumToMaxAmountInLenders < ActiveRecord::Migration
  def change
    rename_column :lenders, :approved_maximum_cents, :max_amount_cents
  end
end
