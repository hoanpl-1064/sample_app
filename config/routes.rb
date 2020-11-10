Rails.application.routes.draw do
  # get 'static_pages/home'
  # get 'static_pages/help'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope "(:locale)", locale: /en|vi/ do
    get "/home", to: "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users, only: %i(new create show)
  end
end
