# encoding: utf-8

require 'nokogiri'
require 'open-uri'

class FetchData
  @queue = :fetch_data

  def self.perform
    rate_hash = {}
    doc = Nokogiri::HTML(open("http://ebank.spdb.com.cn/net/QueryExchangeRate.do"))
    trs = doc.xpath("//table[@class='table_comm']/tr")
    us_dollar_tr = trs[4]
    spdb_us_dollar_bid_fx = us_dollar_tr.xpath("./td")[2].text()
    rate_hash["bid_fx"] = spdb_us_dollar_bid_fx
    spdb_rate = SpdbRate.last
    build_rate(rate_hash, spdb_rate, "spdb")

    rate_hash = {}
    ccb_doc = Nokogiri::XML(open("http://forex.ccb.com/cn/home/news/jshckpj.xml"))
    ccb_dollar = ccb_doc.xpath(".//ReferencePriceSettlement/CM_CURR_COD[text()='14']")
    unless ccb_dollar.nil?
      ccb_us_dollar_elem = ccb_dollar.first().parent
      ccb_us_dollar_bid_fx = ccb_us_dollar_elem.xpath("./FXR_XCH_BUYIN").text()
      rate_hash["bid_fx"] = uniform_rate(ccb_us_dollar_bid_fx)
      ccb_rate = CcbRate.last
      build_rate(rate_hash, ccb_rate, "ccb")
    end
  end

  def self.uniform_rate(rate)
    return (rate.to_f*100).round(2).to_s
  end

  def self.build_rate(hash, rate_obj, rate_type)
    us_dollar = hash["bid_fx"]
    unless us_dollar.match(/^\d+\.\d{2}$/).nil?
      if lastest_rate = rate_obj
	if lastest_rate.bid_fx.to_s != us_dollar
          rate = rate_obj.class.new(hash)
	  if rate.save
	    if setting = Setting.first
	      Notifier.exchange_notifier_mail(rate).deliver if us_dollar.to_f >= setting.except_rate
	    end
	  end
	end
      else
        case rate_type
        when "spdb"
          rate = SpdbRate.new(hash)
        else
          rate = CcbRate.new(hash)
        end
        rate.bid_fx =  us_dollar
	rate.save
      end
    end
  end
end
