class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.string :bid_fx, default: ""
      t.string :type

      t.timestamps
    end
  end
end
