class Rate < ActiveRecord::Base
  self.per_page = 10
  def self.weekly_rate
    now = Time.now.end_of_day
    seven_days_ago = now - 7.days
    rates = Rate.where(created_at: (seven_days_ago..now))
    date_arr, rate_arr = [], []
    rates.collect do |rate|
      date_arr << rate.created_at.strftime("%Y-%-m-%-d %H:%M")
      rate_arr << rate.bid_fx.to_f
    end
    [date_arr, rate_arr]
  end
end
