class Transaction
  attr_accessor :date, :rate, :amount, :total, :fee, :type

  def initialize(date, rate, amount, total, fee, type)
    @date = date
    @rate = rate
    @amount = amount
    @total = total
    @fee = fee
    @type = type
  end

  def buy?
    @type == "buy"
  end

  def sell?
    @type == "sell"
  end

  def merge(transaction)
    @amount += transaction.amount
    @total += transaction.total
  end

  def close(amount)
    close_total = (amount / @amount) * @total
    @total *= (1 - (amount / @amount))
    @amount -= amount
    Transaction.new(@date, @rate, amount, close_total, @fee, @type)
  end

  def apply_fee
    apply_fee_to_amount if buy?
    apply_fee_to_total if sell?
    self
  end

  private

  def apply_fee_to_amount
    @amount -= (@amount * @fee).truncate(8)
  end

  def apply_fee_to_total
    @total -= (@total * @fee).round(8)
  end
end
