Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'videos#index'

  [
    'transcribed', 'not_transcribed',
    'auto_transcribed', 'not_auto_transcribed',
    'transcribed_both', 'transcribed_neither'
  ].each do |list_name|
    get "/#{list_name}", to: 'videos#helpful_list', list_name: list_name, as: "#{list_name}_videos"
  end

  resources :videos, except: [:edit, :update, :destroy] do
    member do
      post 'auto_transcription'
      post 'transcription'
    end
  end

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  delete 'signout', to: 'sessions#destroy', as: 'logout'
  get '/login', to: 'sessions#new'
end
