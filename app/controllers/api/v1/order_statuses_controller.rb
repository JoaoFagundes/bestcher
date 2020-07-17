module API
  module V1
    class OrderStatusesController < ::ApplicationController
      def show
        render status: :ok,
               json: {
                 hello: 'world',
               }
      end
    end
  end
end
