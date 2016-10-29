class RenameDealPaymentMaxAndPaymentMinToMaxPaymentAndMinPaymentInDeals < ActiveRecord::Migration
  def change
    rename_column :deals, :payment_min_cents, :min_payment_cents
    rename_column :deals, :payment_max_cents, :max_payment_cents
  end
end
