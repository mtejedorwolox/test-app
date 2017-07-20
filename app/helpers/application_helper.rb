module ApplicationHelper
  def closed_trades
    @closed_trades ||= Trade.includes(:currency).closed.recent
  end
end
