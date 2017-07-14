class ProcessedTransaction < ApplicationRecord
  validates :currency, presence: true

  belongs_to :currency
end
