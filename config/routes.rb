Rails.application.routes.draw do
  resources :posts
  devise_for :users,
    defaults: { format: :json },
    controllers: {
      registrations: :registrations,
      sessions: :sessions
    }
  resources :users
end
