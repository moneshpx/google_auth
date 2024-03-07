Rails.application.routes.draw do
  root 'pages#home' 
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :users do
    resources :posts
  end
end