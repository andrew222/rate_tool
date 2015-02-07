class SpdbRate < Rate
  def self.all_rates
    rates = SpdbRate.order("id asc")
    rates.collect do |rate|
      [(rate.published_at).to_i*1000, rate.bid_fx.to_f]
    end
  end
end
