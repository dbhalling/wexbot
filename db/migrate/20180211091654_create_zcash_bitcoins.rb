class CreateZcashBitcoins < ActiveRecord::Migration[5.1]
  def change
    create_table :zcash_bitcoins do |t|
      t.float :last
      t.float :buy
      t.float :sell
      t.float :target

      t.timestamps
    end
  end
end
