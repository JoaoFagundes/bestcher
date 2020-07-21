module API
  module V1
    module PurchaseChannel
      class OrdersController < ::ApplicationController
        before_action :find_purchase_channel_orders, only: %i[index]

        def index
          render status: :ok,
                  json: {
                    success: true,
                    data: @orders
                  }
        end

        private

        def find_purchase_channel_orders
          return unless params[:purchase_channel_id].present?

          @orders = Order.where(purchase_channel: CGI.unescape(params[:purchase_channel_id]))
          @orders = @orders.where(status: params[:status]) if params[:status].present?
        end
      end
    end
  end
end
