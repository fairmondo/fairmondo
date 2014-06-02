# Devise's version of an ApplicationController
# https://github.com/plataformatec/devise/blob/master/app/controllers/devise_controller.rb
require Gem::Specification.find_by_name('devise').gem_dir.concat('/app/controllers/devise_controller')
DeviseController.class_eval do
  layout :layout

  protected
    def layout
      if request.xhr?
        false
      else
        "application"
      end
    end
end