class RemoveLendersLoanTerm < ActiveRecord::Migration
  def change
    remove_column :lenders, :loan_term
  end
end
