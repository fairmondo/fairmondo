# https://github.com/plataformatec/devise/blob/master/app/controllers/devise/sessions_controller.rb
class SessionsController < Devise::SessionsController
  layout :layout

  private
    def layout
      if request.xhr?
        false
      else
        "application"
      end
    end
end
