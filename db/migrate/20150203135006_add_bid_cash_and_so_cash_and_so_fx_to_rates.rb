class AddBidCashAndSoCashAndSoFxToRates < ActiveRecord::Migration
  def change
    add_column :rates, :bid_cash, :string, default: ""
    add_column :rates, :so_cash, :string, default: ""
    add_column :rates, :so_fx, :string, default: ""
  end
end
