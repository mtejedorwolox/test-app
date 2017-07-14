require 'rest-client'
require 'openssl'
require 'addressable/uri'

class ApplicationController < ActionController::Base

  RESOURCE = RestClient::Resource.new( 'https://www.poloniex.com' )

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
    process_trades
  end

  private

  def process_trades
    params = {
      command: 'returnTradeHistory',
      nonce: nonce,
      start: 0,
      end: Time.now.to_i
    }

    Transactions.process(JSON.parse trade_history(params))
    @trades = Trade.includes(:currency).closed
  end

  def sign(params)
    encoded_data = Addressable::URI.form_encode( params )
    OpenSSL::HMAC.hexdigest( 'sha512', Rails.application.secrets.poloniex_secret , encoded_data )
  end

  def nonce
    (Time.now.to_f * 10000000).to_i
  end

  def trade_history(params, currency_pair = 'all')
    params[:currencyPair] = currency_pair
    RESOURCE['tradingApi'].post params, { Key: Rails.application.secrets.poloniex_key, Sign: sign(params) }
  end
end
