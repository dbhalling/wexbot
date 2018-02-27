class CreateTradeDatumMa1s < ActiveRecord::Migration[5.1]
  def change
    create_table :trade_datum_ma1s do |t|
      t.string :crypto
      t.float :units
      t.float :target
      t.float :btc_equivalent
      t.float :last

      t.timestamps
    end
  end
end
