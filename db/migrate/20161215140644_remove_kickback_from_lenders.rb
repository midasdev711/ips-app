class RemoveKickbackFromLenders < ActiveRecord::Migration[5.0]
  def up
    remove_column :lenders, :kickback
  end

  def down
    ActiveRecord::Base.transaction do
      add_column :lenders, :kickback, :boolean, default: false, null: false

      Lender.where('kickback_rate > 0').update_all(kickback: true)
    end
  end
end
