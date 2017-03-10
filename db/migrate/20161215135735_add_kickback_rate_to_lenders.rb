class AddKickbackRateToLenders < ActiveRecord::Migration[5.0]
  def up
    ActiveRecord::Base.transaction do
      add_column :lenders, :kickback_rate, :decimal, default: 0.0, null: false

      Lender.where(kickback: true).update_all(kickback_rate: 0.15)
    end
  end

  def down
    remove_column :lenders, :kickback_rate
  end
end
