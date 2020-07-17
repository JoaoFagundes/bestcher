module API
  module V1
    module Financial
      class PurchaseChannelController < ::ApplicationController
        def index
          data = report_service.call.to_json

          render status: :ok,
                 json: data
        end

        private

        def report_service
          @report_service ||= Reports::Orders::Financier.new(group_type: :purchase_channel)
        end
      end
    end
  end
end
