class RenameColumnLoanTypeToLoanInLenders < ActiveRecord::Migration[5.0]
  def change
    rename_column :lenders, :loan_type, :loan
    rename_column :options, :loan_type, :loan
    rename_column :insurance_policies, :loan_type, :loan
  end
end
