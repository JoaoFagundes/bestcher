module API
  module V1
    module Batches
      class SendController < ApplicationController
        before_action :find_batch, only: %i[create]

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

        def find_batch
          @batch = Batch.find_by(reference: params[:batch_id])
        end
      end
    end
  end
end
