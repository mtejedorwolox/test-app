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
    close_transaction = sell_transaction.close(self.amount)
    self.end_date = close_transaction.date
    self.end_rate = close_transaction.rate
    self.end_total = close_transaction.total
    self.status = :close
    self.save
  end

  def profit
    end_total - start_total
  end

  def profit_percentage
    (((end_total / start_total) - 1) * 100).truncate(2)
  end
end
