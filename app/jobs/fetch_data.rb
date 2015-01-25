# encoding: utf-8

require 'nokogiri'
require 'open-uri'

class FetchData
  @queue = :fetch_data

  def self.perform
    doc = Nokogiri::HTML(open("http://ebank.spdb.com.cn/net/QueryExchangeRate.do"))
    trs = doc.xpath("//table[@class='table_comm']/tr")
    us_dollar_tr = trs[4]
    us_dollar = us_dollar_tr.xpath("./td")[2].text()
    unless us_dollar.match(/^\d+\.\d{2}$/).nil?
      if lastest_rate = Rate.last
	if lastest_rate.bid_fx.to_s != us_dollar
	  rate = Rate.new(bid_fx: us_dollar)
	  if rate.save
	    if setting = Setting.first
	      Notifier.exchange_notifier_mail(rate).deliver if us_dollar.to_f >= setting.except_rate
	    end
	  end
	end
      else
	rate = Rate.new(bid_fx: us_dollar)
	rate.save
      end
    end
  end
end
