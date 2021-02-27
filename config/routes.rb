Rails.application.routes.draw do
  devise_for :users,
    defaults: { format: :json },
    controllers: {
      registrations: :registrations,
      sessions: :sessions
    }
  resources :users
end
