class Order < ApplicationRecord
  STATUSES = %i[ready production closing sent]

  belongs_to :batch, optional: true

  validates :reference, presence: true, uniqueness: { case_sensitive: false }
  validates :purchase_channel, presence: true
  validates :address, presence: true
  validates :delivery_service, presence: true
  validates :total_value, presence: true, numericality: { greater_than: 0, only_integer: false }
  validates :batch, presence: true, if: -> { !ready? }
  validates :batch, absence: true, if: -> { ready? }

  enum status: STATUSES
end
