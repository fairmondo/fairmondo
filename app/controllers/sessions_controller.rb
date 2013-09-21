# https://github.com/plataformatec/devise/blob/master/app/controllers/devise/sessions_controller.rb
class SessionsController < Devise::SessionsController
  layout :layout

  skip_before_filter :check_new_terms

  private
    def layout
      if request.xhr?
        false
      else
        "application"
      end
    end
end
