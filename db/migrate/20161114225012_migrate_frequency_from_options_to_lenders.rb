class MigrateFrequencyFromOptionsToLenders < ActiveRecord::Migration[5.0]
  def up
    Lender.all.each do |lender|
      payment_frequency = lender.options.first.try :payment_frequency

      if payment_frequency
        lender.update_columns frequency: payment_frequency
      else
        lender.deal.update_columns state: 'worksheet'
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
