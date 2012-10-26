Rails.application.routes.draw do

  root :to => "home#welcome"

  get "home/welcome"

  mount Tinycms::Engine => "/tinycms"
end
