module API
  module V1
    class OrdersController < ::ApplicationController
      def create
        if order_creator_service.call
          render status: :created,
                 json: { success: true }
        else
          render status: :unprocessable_entity,
                 json: {
                   errors: order_creator_service.errors.full_messages.to_sentence,
                   success: false
                 }
        end
      end

      private

      def order_creator_service
        @order_creator_service ||= Orders::Creator.new(order_params)
      end

      def order_params
        params.permit(:reference, :purchase_channel, :address, :delivery_service, :total_value, :line_items, :client)
              .merge(status: :ready)
      end
    end
  end
end
