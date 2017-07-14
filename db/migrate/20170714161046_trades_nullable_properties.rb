class TradesNullableProperties < ActiveRecord::Migration[5.0]
  def change
    change_column :trades, :end_date, :datetime, null: true
    change_column :trades, :end_rate, :decimal, null: true
    change_column :trades, :end_total, :decimal, null: true
  end
end
