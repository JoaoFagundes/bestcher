module API
  module V1
    module Batches
      class SendController < BaseController
        def create
          if @batch.present?
            if batch_status_updater_service.call
              render status: :ok,
                     json: { success: true }
            else
              render status: :unprocessable_entity,
                     json: {
                       errors: batch_status_updater_service.errors.full_messages,
                       success: false
                     }
            end
          else
            render status: :not_found,
                   json: {
                     errors: "Batch not found",
                     success: false
                   }
          end
        end

        private

        def batch_status_updater_service
          @batch_status_updater_service ||= ::Batches::StatusUpdater.new(@batch,
                                                                         :sent,
                                                                         delivery_service: params[:delivery_service])
        end
      end
    end
  end
end
