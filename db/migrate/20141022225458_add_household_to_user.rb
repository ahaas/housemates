class AddHouseholdToUser < ActiveRecord::Migration
  def change
    add_reference :users, :household, index: true
  end
end
