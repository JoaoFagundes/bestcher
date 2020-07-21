module Batches
  class Creator
    include ActiveModel::Validations

    attr_reader :purchase_channel

    validates :purchase_channel, presence: true
    validate :purchase_channel_with_orders

    def initialize(purchase_channel)
      @purchase_channel = CGI.unescape(purchase_channel) if purchase_channel.present?
    end

    def call
      call!

      true
    rescue ActiveRecord::RecordInvalid
      false
    end

    def call!
      ActiveRecord::Base.transaction do
        fail ActiveRecord::RecordInvalid, self unless valid?

        batch.save!
        orders.each { |order| order.update!(batch: batch, status: :production) }
      end
    end

    def all_errors
      errors&.full_messages&.to_sentence || batch.errors
    end

    private

    def batch
      @batch ||= Batch.new(purchase_channel: purchase_channel, reference: Batch.next_reference)
    end

    def orders
      @orders ||= Order.ready.where(purchase_channel: purchase_channel)
    end

    def purchase_channel_with_orders
      return if orders.present?
      return if purchase_channel.nil?

      errors.add(:base, "The specified purchase channel has no orders.")
    end
  end
end
