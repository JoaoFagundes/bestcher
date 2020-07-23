Rails.application.routes.draw do
  scope module: :api do
    namespace :v1 do
      resources :orders, only: %i[create]
      resource :order_status, only: %i[show]

      resources :purchase_channel, only: %i[] do
        resources :orders, only: %i[index], controller: "purchase_channel/orders"
      end

      resources :batches, only: %i[create] do
        resources :close, only: %i[create], controller: "batches/close"
        resources :send, only: %i[create], controller: "batches/send"
      end

      namespace :financial do
        resources :purchase_channel, only: %i[index]
      end
    end
  end
end
