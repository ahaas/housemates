class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.references :household, index: true
      t.references :user, index: true
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
