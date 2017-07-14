class AddTradeReferencesCurrency < ActiveRecord::Migration[5.0]
  def change
    add_reference :trades, :currency, index: true
  end
end
