module API
  module V1
    class OrderStatusesController < ::ApplicationController
      before_action :find_order, only: %i[show]

      def show
        if @order.present?
          render status: :ok,
                 json: {
                   data: [{
                     status: @order.status
                   }]
                 }
        elsif @orders.present?
          render status: :ok,
                 json: {
                   data: @orders.map { |order| order.slice(:reference, :status) }
                 }
        else
          render status: :not_found,
                 json: {}
        end
      end

      private

      def find_order
        reference_id = params["reference_id"]
        client_name = params["client_name"]

        @order = Order.find_by(reference: reference_id) if reference_id.present?
        @orders = Order.where(client: client_name) if client_name.present?
      end
    end
  end
end
