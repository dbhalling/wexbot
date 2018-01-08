class CreateTradeData < ActiveRecord::Migration[5.1]
  def change
    create_table :trade_data do |t|
      t.text :crypto
      t.float :units
      t.float :target
      t.float :btc_equivalent
      t.float :last

      t.timestamps
    end
  end
end
