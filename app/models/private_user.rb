class PrivateUser < User

    # see http://stackoverflow.com/questions/6146317/is-subclassing-a-user-model-really-bad-to-do-in-rails
    def self.model_name
      User.model_name
    end

end