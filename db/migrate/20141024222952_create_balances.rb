class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.references :user1, index: true
      t.references :user2, index: true
      t.decimal :amount, :default => 0

      t.timestamps
    end
  end
end
