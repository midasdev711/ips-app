class MigrateFloatInterestRatesToAssociationInLenders < ActiveRecord::Migration
  def up
    Lender.all.each do |lender|
      option = lender.options.first
      next unless option
      lender.update_columns interest_rate_id: lender.interest_rates.find_by_value(option.interest_rate).id
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
