#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class CleverreachAPI
  class << self
    def add user
      call :receiver_add, message_with(user: { email: user.email }) rescue false # mostly rescuing TimeOut
    end

    def remove user
      call :receiver_delete, message_with(email: user.email) rescue false
    end

    def get_status user
      response = call :receiver_get_by_email, message_with(email: user.email)
      response.to_hash[:receiver_get_by_email_response][:return][:status] == 'SUCCESS' rescue false
    end

    def client
      Savon.client wsdl: 'http://api.cleverreach.com/soap/interface_v5.1.php?wsdl'
    end

    def message_with hash
      { apiKey: API_KEY, listId: LIST_ID }.merge hash rescue hash # in case api key wasn't defined
    end

    def call function, message
      Timeout.timeout(10) do # 10 second timeout
        client.call function, message: message
      end
    end
  end
end
