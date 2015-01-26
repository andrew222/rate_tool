class Rate < ActiveRecord::Base
  self.per_page = 10
  def self.weekly_rate
    now = Time.now.end_of_day
    seven_days_ago = now - 7.days
    rates = Rate.where(created_at: (seven_days_ago..now))
    rates.collect do |rate|
      [(rate.created_at.gmtime + 28800).strftime("%Y-%-m-%-d %H:%M"), rate.bid_fx.to_f]
    end
  end
end
