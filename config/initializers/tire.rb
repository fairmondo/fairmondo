Tire::Model::Search.index_prefix "fairnopoly_#{Rails.env.to_s.downcase}"

if Rails.env.production?
  Tire.configure do
     url    'http://10.0.2.180:9200'
  end
end
