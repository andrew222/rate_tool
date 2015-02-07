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

  def self.growth_rate(days_before)
    now = Time.now
    if now.utc?
      Time.zone = "Beijing"
      now = Time.zone.now
    end
    new_date = now - days_before.day
    old_date = new_date - 1.day
    old_rate = SpdbRate.where(created_at: (old_date.beginning_of_day..old_date.end_of_day)).last
    new_rate = SpdbRate.where(created_at: (new_date.beginning_of_day..new_date.end_of_day)).last
    unless old_rate.nil? || new_rate.nil?
      ((new_rate.bid_fx.to_f - old_rate.bid_fx.to_f)/old_rate.bid_fx.to_f)*100
    else
      new_date = SpdbRate.last.created_at
      old_date = new_date - 1.day
      old_rate = SpdbRate.where(created_at: (old_date.beginning_of_day..old_date.end_of_day)).last
      new_rate = SpdbRate.where(created_at: (new_date.beginning_of_day..new_date.end_of_day)).last
      ((new_rate.bid_fx.to_f - old_rate.bid_fx.to_f)/old_rate.bid_fx.to_f)*100
    end
  end
end
