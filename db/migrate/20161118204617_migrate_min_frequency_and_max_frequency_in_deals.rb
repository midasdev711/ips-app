class MigrateMinFrequencyAndMaxFrequencyInDeals < ActiveRecord::Migration[5.0]
  def up
    Deal.all.each do |deal|
      deal.min_frequency = deal.payment_frequency_min
      deal.max_frequency = deal.payment_frequency_max
      deal.save! validate: false
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
