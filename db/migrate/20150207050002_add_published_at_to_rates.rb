class AddPublishedAtToRates < ActiveRecord::Migration
  def change
    add_column :rates, :published_at, :datetime
  end
end
