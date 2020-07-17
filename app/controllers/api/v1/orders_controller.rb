module API
  module V1
    class OrdersController < ::ApplicationController
      def create
        render status: :created,
               json: {
                 hello: 'world',
               }
      end
    end
  end
end
