class Currency < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :processed_transactions
  has_many :trades
end
