class AddInsurancePoliciesLoanType < ActiveRecord::Migration
  def change
    add_column :insurance_policies, :loan_type, :integer
  end
end
