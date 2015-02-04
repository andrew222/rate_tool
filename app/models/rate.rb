class Rate < ActiveRecord::Base
  self.per_page = 10
  def self.weekly_rate
    now = Time.now.end_of_day
    seven_days_ago = now - 7.days
    rates = SpdbRate.where(created_at: (seven_days_ago..now))
    rates.collect do |rate|
      [(rate.created_at).to_i*1000, rate.bid_fx.to_f]
    end
  end

  def self.all_rates
    rates = SpdbRate.all
    rates.collect do |rate|
      [(rate.created_at).to_i*1000, rate.bid_fx.to_f]
    end
  end
end
