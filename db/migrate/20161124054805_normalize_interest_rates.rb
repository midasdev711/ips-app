class NormalizeInterestRates < ActiveRecord::Migration[5.0]
  def up
    InterestRate.all.each do |interest_rate|
      interest_rate.percent_value = interest_rate.value
      interest_rate.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
