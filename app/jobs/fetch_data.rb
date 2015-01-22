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
    if lastest_rate = Rate.last
      if lastest_rate.to_s != us_dollar
	rate = Rate.new(value: us_dollar.to_f)
	rate.save
      end
      p 'resque test'
    end
  end
end
