class CreateUsdma1s < ActiveRecord::Migration[5.1]
  def change
    create_table :usdma1s do |t|
      t.float :last
      t.float :buy
      t.float :sell

      t.timestamps
    end
  end
end
