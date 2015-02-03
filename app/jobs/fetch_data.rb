# encoding: utf-8

require 'nokogiri'
require 'open-uri'

class FetchData
  @queue = :fetch_data

  def self.perform
    doc = Nokogiri::HTML(open("http://ebank.spdb.com.cn/net/QueryExchangeRate.do"))
    trs = doc.xpath("//table[@class='table_comm']/tr")
    us_dollar_tr = trs[4]
    spdb_us_dollar = us_dollar_tr.xpath("./td")[2].text()
    build_rate(spdb_us_dollar)

    ccb_doc = Nokogiri::XML(open("http://forex.ccb.com/cn/home/news/jshckpj.xml"))
    ccb_dollar = ccb_doc.xpath(".//ReferencePriceSettlement/CM_CURR_COD[text()='14']")
    unless ccb_dollar.nil?
      unless ccb_us_dollar_elem = ccb_dollar.first().parent
        cbb_us_dollar = ccb_us_dollar_elem.xpath("./FXR_XCH_BUYIN").text()
        build_rate(cbb_us_dollar.to_f*100.round(2).to_s)
      end
    end
  end

  def build_rate(us_dollar)
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
