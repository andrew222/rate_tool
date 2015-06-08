# encoding: utf-8

require 'nokogiri'
require 'open-uri'

class FetchData
  include Sidekiq::Worker
  sidekiq_options :failures => true

  def perform
    rate_hash = {}
    doc = Nokogiri::HTML(open("http://ebank.spdb.com.cn/net/QueryExchangeRate.do"))
    trs = doc.xpath("//table[@class='table_comm']/tr")
    us_dollar_tr = trs[4]
    spdb_us_dollar_mid = us_dollar_tr.xpath("./td")[1].text()
    spdb_us_dollar_bid_fx = us_dollar_tr.xpath("./td")[2].text()
    spdb_us_dollar_bid_cash = us_dollar_tr.xpath("./td")[3].text()
    spdb_us_dollar_so_cash = us_dollar_tr.xpath("./td")[4].text()
    spdb_us_dollar_so_fx = spdb_us_dollar_so_cash
    rate_hash["so_cash"] = spdb_us_dollar_so_cash
    rate_hash["mid"] = spdb_us_dollar_mid
    rate_hash["bid_fx"] = spdb_us_dollar_bid_fx
    rate_hash["bid_cash"] = spdb_us_dollar_bid_cash
    rate_hash["so_cash"] = spdb_us_dollar_so_cash
    rate_hash["so_fx"] = spdb_us_dollar_so_fx
    datetime_str = doc.xpath(".//div[@class='mainDiv']/div").text()
    rate_hash["published_at"] = uniform_datetime(datetime_str)
    spdb_rate = SpdbRate.last
    build_rate(rate_hash, spdb_rate, "spdb")

    rate_hash = {}
    ccb_doc = Nokogiri::XML(open("http://forex.ccb.com/cn/home/news/jshckpj.xml"))
    datetime_str = ccb_doc.xpath(".//ReferencePriceSettlements/TIMESTAMP").text()
    rate_hash["published_at"] = uniform_datetime(datetime_str)
    ccb_dollar = ccb_doc.xpath(".//ReferencePriceSettlement/CM_CURR_COD[text()='14']")
    unless ccb_dollar.nil?
      ccb_us_dollar_elem = ccb_dollar.first().parent
      ccb_us_dollar_bid_fx = ccb_us_dollar_elem.xpath("./FXR_XCH_BUYIN").text()
      ccb_us_dollar_so_cash = ccb_us_dollar_elem.xpath("./FXR_XCH_SELLOUT").text()
      ccb_us_dollar_so_fx = ccb_us_dollar_so_cash
      ccb_us_dollar_bid_cash = ccb_us_dollar_elem.xpath("./FXR_CUR_BUYIN").text()
      ccb_us_dollar_mid = ccb_us_dollar_elem.xpath("./MID_RATE").text()
      rate_hash["bid_fx"] = uniform_rate(ccb_us_dollar_bid_fx)
      rate_hash["so_cash"] = uniform_rate(ccb_us_dollar_so_cash)
      rate_hash["so_fx"] = uniform_rate(ccb_us_dollar_so_fx)
      rate_hash["bid_cash"] = uniform_rate(ccb_us_dollar_bid_cash)
      rate_hash["mid"] = uniform_rate(ccb_us_dollar_mid)
      ccb_rate = CcbRate.last
      build_rate(rate_hash, ccb_rate, "ccb")
    end

    rate_hash = {}
    boc_doc = Nokogiri::XML(open("http://srh.bankofchina.com/search/whpj/search.jsp?pjname=1316"))
    boc_dollar_table = boc_doc.xpath(".//div[contains(@class, 'BOC_main')]/table")
    unless boc_dollar_table.nil?
      boc_us_dollar_tr = boc_dollar_table.xpath(".//tr")[1]
      boc_us_dollar_elem = boc_us_dollar_tr.xpath("./td")
      boc_us_dollar_bid_fx = boc_us_dollar_elem[1].text()
      boc_us_dollar_bid_cash = boc_us_dollar_elem[2].text()
      boc_us_dollar_so_fx = boc_us_dollar_elem[3].text()
      boc_us_dollar_so_cash = boc_us_dollar_elem[4].text()
      boc_us_dollar_mid = boc_us_dollar_elem[5].text()
      rate_hash["bid_fx"] = boc_us_dollar_bid_fx
      rate_hash["so_cash"] = boc_us_dollar_so_cash
      rate_hash["so_fx"] = boc_us_dollar_so_fx
      rate_hash["bid_cash"] = boc_us_dollar_bid_cash
      rate_hash["mid"] = boc_us_dollar_mid
      datetime_str = boc_us_dollar_elem[7].text()
      rate_hash["published_at"] = uniform_datetime(datetime_str)
      boc_rate = BocRate.last
      build_rate(rate_hash, boc_rate, "boc")
    end
  end

  def uniform_rate(rate)
    return (rate.to_f*100).round(2).to_s
  end

  def uniform_datetime(str)
    unless str.blank?
      Time.zone.parse(str)
    else
      Time.current
    end
  end
  def build_rate(hash, rate_obj, rate_type)
    us_dollar = hash["bid_fx"]
    unless us_dollar.match(/^\d+(\.\d{1,2})?$/).nil?
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
	when "ccb"
          rate = CcbRate.new(hash)
	else
	  rate = BocRate.new(hash)
        end
	rate.save
      end
    end
  end
end
