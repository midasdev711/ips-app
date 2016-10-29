class MigrateMinFrequencyAndMaxFrequencyInDeals < ActiveRecord::Migration
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
