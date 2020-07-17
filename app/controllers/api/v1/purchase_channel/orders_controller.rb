module API
  module V1
    module PurchaseChannel
      class OrdersController < ::ApplicationController
        def index
          render status: :ok,
                 json: {
                   hello: 'world',
                 }
        end
      end
    end
  end
end
