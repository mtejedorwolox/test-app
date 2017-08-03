class Transactions
  def self.process(transactions_json)
    transactions = map(transactions_json)
    transactions.each do |key, value|
      process_buys(value[:currency], value[:buys])
      process_sells(value[:currency], value[:sells])
    end
  end

  private

  def self.process_buys(currency, buys)
    buys.each do |buy_transaction|
      trade = Trade.open.with_currency(currency).with_start_rate(buy_transaction.rate).recent.first
      if trade.nil?
        Trade.create(
          start_date: buy_transaction.date,
          start_rate: buy_transaction.rate,
          amount: buy_transaction.amount,
          start_total: buy_transaction.total,
          status: :open,
          currency: currency
        )
      else
        trade.amount += transaction.amount
        trade.start_total += transaction.total
        trade.save
      end
    end
  end

  def self.process_sells(currency, sells)
    sells.each do |sell_transaction|
      until (sell_transaction.amount <= 0) do
        trade = Trade.open.with_currency(currency).older_than(sell_transaction.date).first
        if trade.nil?
          # add $$$ to loan
          sell_transaction.amount = 0
        else
          if trade.amount <= sell_transaction.amount
            trade.close(sell_transaction)
          else
            trade.split(sell_transaction)
          end
        end
      end
    end
  end

  def self.map(transactions_json)
    result = {}
    transactions_json.each do |currency_pair, transactions_per_currency|
      currency_name = clean_currency(currency_pair)
      currency = Currency.find_or_create_by(name: currency_name)
      buys = []
      sells = []
      transactions_per_currency.reverse.each do |trade|
        trade_id = trade["tradeID"]
        next if ProcessedTransaction.exists?(trade_id)
        transaction = TransactionBuilder.build_with_json(trade)
        add(buys, transaction) if transaction.buy?
        add(sells, transaction) if transaction.sell?
        process_transaction(trade_id, currency)
      end
      result[currency_name] = {
        buys: buys,
        sells: sells,
        currency: currency
      }
    end
    result
  end

  def self.add(arr, transaction)
    last = arr.last
    if arr.any? && last.rate == transaction.rate
      last.merge(transaction)
    else
      arr.push(transaction)
    end
  end

  def self.process_transaction(trade_id, currency)
    processed_transaction = ProcessedTransaction.new
    processed_transaction.trade_id = trade_id
    processed_transaction.currency = currency
    processed_transaction.save
  end

  def self.clean_currency(currency_pair)
    currency = currency_pair.dup
    currency.slice!('BTC_')
    currency
  end
end
