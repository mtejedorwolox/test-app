require 'rest-client'
require 'openssl'
require 'addressable/uri'

class ApplicationController < ActionController::Base

  KEY = 'my key'.freeze
  SECRET = 'my secret'.freeze
  RESOURCE = RestClient::Resource.new( 'https://www.poloniex.com' ).freeze

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # i18n configuration. See: http://guides.rubyonrails.org/i18n.html
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: locale }
  end

  # for devise to redirect with locale
  def self.default_url_options(options = {})
    options.merge(locale: I18n.locale)
  end

  def index
    params = {
      command: 'returnTradeHistory',
      nonce: nonce,
      start: 0,
      end: Time.now.to_i
    }


    #response = resource[ 'public' ].get params: {command: 'returnCurrencies'}

    @closed_trades = closed_trades(params)
  end

  private

  def sign(params)
    encoded_data = Addressable::URI.form_encode( params )
    OpenSSL::HMAC.hexdigest( 'sha512', SECRET , encoded_data )
  end

  def nonce
    (Time.now.to_f * 10000000).to_i
  end

  def trade_history(params, currency_pair = 'all')
    params[:currencyPair] = currency_pair
    RESOURCE['tradingApi'].post params, { Key: KEY, Sign: sign(params) }
  end

  def closed_trades(params)
    trade_history = JSON.parse trade_history(params)
    trade_history.each do |currency_pair, trades|
      trades.reverse.each do |trade|
        if trade["type"] == 'buy'
          puts "BUY"
        end
      end
    end
    trade_history
  end
end


#
#module Poloniex
#
#  class << self
#    attr_accessor :configuration
#  end
#
#  def self.setup
#    @configuration ||= Configuration.new
#    yield( configuration )
#  end
#
#  class Configuration
#    attr_accessor :key, :secret
#
#    def intialize
#      @key    = ''
#      @secret = ''
#    end
#  end
#
#  def self.get_all_daily_exchange_rates( currency_pair )
#    res = get 'returnChartData', currencyPair: currency_pair, period: 86400,  start: 0, :end => Time.now.to_i
#  end
#
#  def self.ticker
#    get 'returnTicker'
#  end
#
#  def self.volume
#    get 'return24hVolume'
#  end
#
#  def self.order_book( currency_pair )
#    get 'returnOrderBook', currencyPair: currency_pair
#  end
#
#  def self.active_loans
#    post 'returnActiveLoans'
#  end
#
#  def self.balances
#    post 'returnBalances'
#  end
#
#  def self.lending_history( start = 0, end_time = Time.now.to_i )
#    post 'returnLendingHistory', start: start, :end => end_time
#  end
#
#  def self.currencies
#    get 'returnCurrencies'
#  end
#
#  def self.complete_balances
#    post 'returnCompleteBalances'
#  end
#
#  def self.open_orders( currency_pair )
#    post 'returnOpenOrders', currencyPair: currency_pair
#  end
#
#  def self.trade_history( currency_pair, start = 0, end_time = Time.now.to_i )
#    post 'returnTradeHistory', currencyPair: currency_pair, start: start, :end => end_time
#  end
#
#  def self.buy( currency_pair, rate, amount )
#    post 'buy', currencyPair: currency_pair, rate: rate, amount: amount
#  end
#
#  def self.sell( currency_pair, rate, amount )
#    post 'sell', currencyPair: currency_pair, rate: rate, amount: amount
#  end
#
#  def self.cancel_order( currency_pair, order_number )
#    post 'cancelOrder', currencyPair: currency_pair, orderNumber: order_number
#  end
#
#  def self.move_order( order_number, rate )
#    post 'moveOrder', orderNumber: order_number, rate: rate
#  end
#
#  def self.withdraw( currency, amount, address )
#    post 'widthdraw', currency: currency, amount: amount, address: address
#  end
#
#  def self.available_account_balances
#    post 'returnAvailableAccountBalances'
#  end
#
#  def self.tradable_balances
#    post 'returnTradableBalances'
#  end
#
#  def self.transfer_balance( currency, amount, from_ccount, to_account )
#    post 'transferBalance', currency: currency, amount: amount, fromAccount: from_ccount, toAccount: to_account
#  end
#
#  def self.margin_account_summary
#    post 'returnMarginAccountSummary'
#  end
#
#  def self.margin_buy(currency_pair, rate, amount)
#    post 'marginBuy', currencyPair: currency_pair, rate: rate, amount: amount
#  end
#
#  def self.margin_sell(currency_pair, rate, amount)
#    post 'marginSell', currencyPair: currency_pair, rate: rate, amount: amount
#  end
#
#  def self.deposit_addresses
#    post 'returnDepositAddresses'
#  end
#
#  def self.generate_new_address( currency )
#    post 'generateNewAddress', currency: currency
#  end
#
#  def self.deposits_withdrawls( start = 0, end_time = Time.now.to_i )
#    post 'returnDepositsWithdrawals', start: start, :end => end_time
#  end
#
#  protected
#
#  def self.resource
#    @@resouce ||= RestClient::Resource.new( 'https://www.poloniex.com' )
#  end
#
#  def self.get( command, params = {} )
#    params[:command] = command
#    resource[ 'public' ].get params: params
#  end
#
#  def self.post( command, params = {} )
#    params[:command] = command
#    params[:nonce]   = (Time.now.to_f * 10000000).to_i
#    resource[ 'tradingApi' ].post params, { Key: configuration.key , Sign: create_sign( params ) }
#  end
#
#  def self.create_sign( data )
#    encoded_data = Addressable::URI.form_encode( data )
#    OpenSSL::HMAC.hexdigest( 'sha512', configuration.secret , encoded_data )
#  end
#
#end