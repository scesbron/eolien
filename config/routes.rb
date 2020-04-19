Rails.application.routes.draw do
  devise_for :users,
             path: 'api',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             },
             controllers: {
               sessions: 'sessions',
               passwords: 'passwords'
             }
  namespace :api, defaults: { format: :json } do
    resource :user, only: [:show, :update]
  end
end
