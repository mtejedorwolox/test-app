class ChangeStatusToInteger < ActiveRecord::Migration[5.0]
  def change
    change_column :trades, :status, :integer
  end
end
