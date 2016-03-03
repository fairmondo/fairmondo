#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'sinatra/base'
require 'rack/contrib'

class FakeFastbill < Sinatra::Base
  use ::Rack::PostBodyContentTypeParser

  use Rack::Auth::Basic do |username, password|
    username == 'my_email' && password == 'my_fastbill_api_key'
  end

  post '/api/1.0/api.php' do
    case params['service']
    when 'customer.create'
      json_response 'customer_create_response.json'
    when 'subscription.create'
      json_response 'subscription_create_response.json'
    when 'subscription.setusagedata'
      json_response 'subscription_set_usage_data_response.json'
    else
      json_response 'standard_response.json'
    end
  end

  private

  def json_response(file_name)
    content_type :json
    status 200
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
