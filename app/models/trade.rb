class Trade < ApplicationRecord
  enum status: [ :open, :close ]

  validates :start_date, :start_rate, :amount, :start_total, :status, :currency, presence: true

  belongs_to :currency

  scope :open, -> { where(status: :open) }

  scope :closed, -> { where(status: :close) }

  scope :with_currency, ->(currency) { where(currency: currency) }

  scope :with_start_rate, ->(start_rate) { where(start_rate: start_rate) }

  scope :older_than, ->(date) { where('start_date < ?', date).order(start_date: :asc) }

  scope :recent, -> { order(start_date: :desc) }

  def close(sell_transaction)
    close_transaction = sell_transaction.close(self.amount)
    self.end_date = close_transaction.date
    self.end_rate = close_transaction.rate
    self.end_total = close_transaction.total
    self.status = :close
    self.save
  end

  def split(sell_transaction)
    trade = Trade.new(
      start_date: self.start_date,
      start_rate: self.start_rate,
      status: self.status,
      currency: self.currency
    )
    trade.amount = self.amount - sell_transaction.amount
    trade.start_total = self.start_total * (trade.amount / self.amount)
    trade.save

    self.start_total *= (sell_transaction.amount / self.amount)
    self.amount = sell_transaction.amount
    close(sell_transaction)
  end

  def profit
    end_total - start_total
  end

  def profit_percentage
    (((end_total / start_total) - 1) * 100).truncate(2)
  end
end
