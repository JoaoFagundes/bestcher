Rails.application.routes.draw do
  scope module: :api do
    namespace :v1 do
      resources :orders, only: %i[create]
      resource :order_status, only: %i[show]

      resources :purchase_channel, only: %i[] do
        resources :orders, only: %i[index], controller: "purchase_channel/orders"
      end
    end
  end
end
