require "geoip"
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_locale

  def set_locale
    data_file_path = "#{Rails.root}/GeoIP.dat"
    unless Rails.env.development?
      data_file_path = "#{Rails.root}/public/system/GeoIP.dat"
    end
    remote_ip = request.remote_ip
    if session[remote_ip].nil?
      result = GeoIP.new(data_file_path).country(remote_ip)
      if !result.nil? && result.to_hash[:country] != "China"
	session[remote_ip] = "en"
      else
	session[remote_ip] = "zh-CN"
      end
    end
    I18n.locale = session[remote_ip]
  end
end
