class CreateProcessedTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :processed_transactions, primary_key: :trade_id do |t|
      t.references :currency, index: true
      t.timestamps
    end
  end
end
