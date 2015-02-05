class SpdbRate < Rate
  def self.all_rates
    rates = SpdbRate.all.order("created_at desc")
    rates.collect do |rate|
      [(rate.created_at).to_i*1000, rate.bid_fx.to_f]
    end
  end
end
