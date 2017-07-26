module ApplicationHelper
  RESOURCE = RestClient::Resource.new( 'https://www.poloniex.com' )

  def closed_trades
    @closed_trades ||= Trade.includes(:currency).closed.recent
  end

  def open_trades
    @open_trades ||= Trade.includes(:currency).open.recent
    @open_trades.each do |trade|
      currency_pair = 'BTC_' + trade.currency.name
      trade.end_total = (trade.amount * BigDecimal(@ticker[currency_pair]['last'])).round(8)
    end
  end

  def process_trades
    Transactions.process(JSON.parse trade_history)
    @ticker = JSON.parse ticker
  end

  private

  def sign(params)
    encoded_data = Addressable::URI.form_encode( params )
    OpenSSL::HMAC.hexdigest( 'sha512', Rails.application.secrets.poloniex_secret , encoded_data )
  end

  def nonce
    (Time.now.to_f * 10000000).to_i
  end

  def trade_history
    params = {
      command: 'returnTradeHistory',
      nonce: nonce,
      start: 0,
      end: Time.now.to_i,
      currencyPair: 'all'
    }

    RESOURCE['tradingApi'].post params, { Key: Rails.application.secrets.poloniex_key, Sign: sign(params) }
  end

  def ticker
    RESOURCE['public?command=returnTicker'].get
  end
end
