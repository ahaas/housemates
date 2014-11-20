class AddRefToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :user, index: true
    add_reference :tasks, :household, index: true
  end
end
