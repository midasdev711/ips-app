class ConvertLenderResidualToCents < ActiveRecord::Migration
  def change
    rename_column :lenders, :residual, :residual_cents

    Lender.all.each do |ln|
      ln.update_attributes residual_cents: ln.residual_cents * 100
    end
  end
end
