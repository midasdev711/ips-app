class MoveResidualDataFromInsurancePoliciesToInsuranceTerms < ActiveRecord::Migration[5.0]
  def up
    InsuranceTerm.includes(:insurance_policy).all.each do |insurance_term|
      insurance_policy = insurance_term.insurance_policy

      if insurance_policy
        insurance_term.update_columns residual: insurance_policy.residual
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
