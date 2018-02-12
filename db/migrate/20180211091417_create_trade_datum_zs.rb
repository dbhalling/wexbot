class CreateTradeDatumZs < ActiveRecord::Migration[5.1]
  def change
    create_table :trade_datum_zs do |t|
      t.text :crypto
      t.float :units
      t.float :target
      t.float :btc_equivalent
      t.float :last

      t.timestamps
    end
  end
end
