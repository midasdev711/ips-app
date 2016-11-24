class MigrateFrequencyFromOptionsToLenders < ActiveRecord::Migration[5.0]
  def up
    Lender.all.each do |lender|
      option = lender.options.first
      next unless option
      lender.frequency = option.payment_frequency
      lender.save! validate: false
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
