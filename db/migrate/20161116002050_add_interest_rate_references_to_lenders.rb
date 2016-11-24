class AddInterestRateReferencesToLenders < ActiveRecord::Migration[5.0]
  def change
    add_reference :lenders, :interest_rate
  end
end
