Rails.application.routes.draw do
  root to: 'videos#index'
  resources :videos, except: [:edit, :destroy] do
    member do
      post 'auto_transcription'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
