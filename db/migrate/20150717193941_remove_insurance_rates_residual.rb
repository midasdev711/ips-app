class RemoveInsuranceRatesResidual < ActiveRecord::Migration
  def change
    remove_column :insurance_rates, :residual, :boolean
  end
end
