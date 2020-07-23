module API
  module V1
    class BatchesController < ::ApplicationController
      def create
        if batch_creator_service.call
          render status: :created,
                 json: { success: true }
        else
          render status: :unprocessable_entity,
                 json: {
                   errors: batch_creator_service.all_errors,
                   success: false
                 }
        end
      end

      private

      def batch_creator_service
        @batch_creator_service ||= Batches::Creator.new(params[:purchase_channel])
      end
    end
  end
end
