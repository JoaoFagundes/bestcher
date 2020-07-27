class Batch < ApplicationRecord
  has_many :orders

  validates :reference, presence: true, uniqueness: { case_sensitive: false }
  validates :purchase_channel, presence: true
  validate :orders_have_same_purchase_channel

  def self.next_reference
    Batch.last&.reference.to_i + 1
  end

  private

  def orders_have_same_purchase_channel
    return if orders.empty? || orders.reject { |order| order.purchase_channel == self.purchase_channel }.empty?

    errors.add(:base, "All the orders must be from the same purchase channel as the batch.")
  end
end
