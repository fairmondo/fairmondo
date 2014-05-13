class CleverreachAPI
  require 'savon'

  def self.add user
    call :receiver_add, message_with( user: { email: user.email } )
  rescue Timeout::Error
    false
  end

  def self.remove user
    call :receiver_delete, message_with( email: user.email )
  rescue Timeout::Error
    false
  end

  def self.get_status user
    response = call :receiver_get_by_email, message_with( email: user.email )
    response.to_hash[:receiver_get_by_email_response][:return][:status] == 'SUCCESS' rescue false
  end

  private
    def self.client
      Savon.client wsdl: 'http://api.cleverreach.com/soap/interface_v5.1.php?wsdl'
    end

    def self.message_with hash
      { apiKey: API_KEY, listId: LIST_ID }.merge hash rescue hash # in case api key wasn't defined
    end

    def self.call function, message
      Timeout::timeout(10) do #10 second timeout
        client.call function, message: message
      end
    end
end