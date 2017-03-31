class AddPstAndGstTradeInAllowanceToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :pst_trade_in_allowance, :boolean, default: true
    add_column :deals, :gst_trade_in_allowance, :boolean, default: true
  end
end
