class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :text
      t.references :user, index: true
      t.references :household, index: true

      t.timestamps
    end
  end
end
