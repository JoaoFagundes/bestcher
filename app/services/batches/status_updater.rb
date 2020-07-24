module Batches
  class StatusUpdater
    include ActiveModel::Validations

    attr_reader :batch, :new_status, :delivery_service

    validates :batch, presence: true
    validates :delivery_service, presence: true, if: -> { new_status == :sent }
    validate :valid_new_status

    def initialize(batch, new_status, delivery_service: nil)
      @batch = batch
      @new_status = new_status
      @delivery_service = delivery_service
    end

    def call
      call!

      true
    rescue ActiveModel::ValidationError, ActiveRecord::RecordInvalid
      false
    end

    def call!
      ActiveRecord::Base.transaction do
        validate!

        orders.each { |order| order.update!(status: new_status) }
      end
    end

    private

    def orders
      @orders ||= begin
        orders = batch.orders
        orders = orders.where(delivery_service: delivery_service) if delivery_service.present?

        orders
      end
    end

    def valid_new_status
      return if new_status == orders.take.next_status

      errors.add(:base, "Can't change from #{orders.take.status} to #{new_status}.")
    end
  end
end
