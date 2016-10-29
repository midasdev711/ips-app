class AddInterestRateReferencesToLenders < ActiveRecord::Migration
  def change
    add_reference :lenders, :interest_rate
  end
end
