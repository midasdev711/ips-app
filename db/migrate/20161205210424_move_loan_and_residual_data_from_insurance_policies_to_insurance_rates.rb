class MoveLoanAndResidualDataFromInsurancePoliciesToInsuranceRates < ActiveRecord::Migration[5.0]
  def up
    InsurancePolicy.all.each do |insurance_policy|
      insurance_policy.insurance_rates.update_all loan: insurance_policy.loan, residual: insurance_policy.residual
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
