class RenameColumnLoanTypeToLoanInLenders < ActiveRecord::Migration
  def change
    rename_column :lenders, :loan_type, :loan
    rename_column :options, :loan_type, :loan
    rename_column :insurance_policies, :loan_type, :loan
  end
end
