class Batch < ApplicationRecord
  has_many :orders

  validates :reference, presence: true, uniqueness: { case_sensitive: false }
  validates :purchase_channel, presence: true

  def self.next_reference
    Batch.last&.reference.to_i + 1
  end
end
