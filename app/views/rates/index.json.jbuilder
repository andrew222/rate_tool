json.array!(@rates) do |rate|
  json.extract! rate, :id, :type, :bid_fix
  json.url rate_url(rate, format: :json)
end
