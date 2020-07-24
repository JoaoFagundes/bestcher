module API
  module V1
    module Batches
      class BaseController < ApplicationController
        before_action :find_batch

        private

        def find_batch
          @batch = Batch.find_by(reference: params[:batch_id])
        end
      end
    end
  end
end
