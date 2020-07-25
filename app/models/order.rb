class Order < ApplicationRecord
  STATUSES = %i[ready production closing sent]

  belongs_to :batch, optional: true

  validates :reference, presence: true, uniqueness: { case_sensitive: false }
  validates :purchase_channel, presence: true
  validates :client, presence: true
  validates :address, presence: true
  validates :delivery_service, presence: true
  validates :total_value, presence: true, numericality: { greater_than: 0, only_integer: false }
  validates :line_items, presence: true
  validates :status, presence: true
  validates :batch, presence: true, if: -> { status.present? && !ready? }
  validates :batch, absence: true, if: -> { status.present? && ready? }

  enum status: STATUSES

  def next_status
    case status.to_sym
    when :ready; :production
    when :production; :closing
    when :closing; :sent
    end
  end
end
