class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.float :value, default: 0
      t.string :type

      t.timestamps
    end
  end
end
