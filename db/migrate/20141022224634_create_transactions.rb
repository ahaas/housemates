class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :payer, index: true
      t.references :payee, index: true
      t.references :household, index: true
      t.references :transaction_group, index: true
      t.boolean :is_payback
      t.decimal :amount

      t.timestamps
    end
  end
end
