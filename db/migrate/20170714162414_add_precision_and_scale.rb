class AddPrecisionAndScale < ActiveRecord::Migration[5.0]
  def change
    change_column :trades, :start_rate,   :decimal, precision: 20, scale: 8
    change_column :trades, :end_rate,     :decimal, precision: 20, scale: 8
    change_column :trades, :amount,       :decimal, precision: 20, scale: 8
    change_column :trades, :start_total,  :decimal, precision: 20, scale: 8
    change_column :trades, :end_total,    :decimal, precision: 20, scale: 8
  end
end
