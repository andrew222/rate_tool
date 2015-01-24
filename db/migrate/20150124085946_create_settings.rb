class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.float :except_rate, default: 0

      t.timestamps
    end
  end
end
