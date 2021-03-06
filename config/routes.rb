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
    resource :wind_farm, only: [] do
      get :init, on: :collection
      get :status, on: :collection
      get :monthly_data, on: :collection
      get :daily_data, on: :collection
      get :yearly_data, on: :collection
    end
  end
end
