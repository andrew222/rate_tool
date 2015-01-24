json.array!(@settings) do |setting|
  json.extract! setting, :id, :except_rate
  json.url setting_url(setting, format: :json)
end
