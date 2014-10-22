class CreateTransactionGroups < ActiveRecord::Migration
  def change
    create_table :transaction_groups do |t|
      t.string :name
      t.float :total_amount

      t.timestamps
    end
  end
end
