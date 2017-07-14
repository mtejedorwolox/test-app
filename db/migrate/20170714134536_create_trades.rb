class CreateTrades < ActiveRecord::Migration[5.0]
  def change
    create_table :trades do |t|
      t.datetime  :start_date,  null: false
      t.datetime  :end_date,    null: false
      t.decimal   :start_rate,  null: false
      t.decimal   :end_rate,    null: false
      t.decimal   :amount,      null: false
      t.decimal   :start_total, null: false
      t.decimal   :end_total,   null: false
      t.decimal   :status,      null: false
      t.timestamps
    end
  end
end
