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
    end
  end

  get '*path', to: 'application#frontend_index_html', constraints: lambda { |request|
    !request.xhr? && request.format.html?
  }
end
