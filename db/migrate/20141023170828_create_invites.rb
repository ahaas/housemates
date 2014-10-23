class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :household, index: true
      t.string :email

      t.timestamps
    end
  end
end
