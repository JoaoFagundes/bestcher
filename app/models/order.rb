class Order < ApplicationRecord
  STATUSES = %i[ready production closing sent]

  belongs_to :batch

  enum status: STATUSES
end
