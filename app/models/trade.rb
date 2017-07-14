class Trade < ApplicationRecord
  enum status: [ :open, :close ]

  validates :start_date, :start_rate, :amount, :start_total, :status, :currency, presence: true

  belongs_to :currency

  scope :open, -> { where(status: :open) }

  scope :closed, -> { where(status: :close) }

  scope :with_currency, ->(currency) { where(currency: currency) }

  scope :with_start_rate, ->(start_rate) { where(start_rate: start_rate) }

  scope :oldest, -> { order(start_date: :asc) }

  scope :recent, -> { order(start_date: :desc) }

  def close(sell_transaction)
    sell_transaction.amount -= self.amount
    self.end_date = sell_transaction.date
    self.end_rate = sell_transaction.rate
    self.end_total = sell_transaction.total
    self.status = :close
    self.save
  end

  def profit
    end_total - start_total
  end
end
