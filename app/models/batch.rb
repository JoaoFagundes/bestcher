class Batch < ApplicationRecord
  has_many :orders

  validates :reference, presence: true, uniqueness: { case_sensitive: false }
  validates :purchase_channel, presence: true
end
