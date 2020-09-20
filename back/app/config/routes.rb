Rails.application.routes.draw do
  # devise_for :users

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      # resources :users
      # resources :sessions
      resources :feeds do
        collection do
          post :sort
        end
      end
    end
  end
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }
end
