#Kevin Sung

require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @u = User.create(name: 'Example User1', email: 'user1@example.com',
                     password: 'letmein', 
                     password_confirmation: 'letmein')
    @hh = Household.create(name: 'Test household')
    @task = Task.new(name: "buy milk", completed: false, household: @hh)
  end
  
  test 'task should be valid' do
    assert @task.valid?
  end
  
  test 'task name should be present' do
    assert @task.name == "buy milk"
  end
  
  test 'task should not be completed' do
    assert_not @task.completed
  end

  test 'household should be present' do
    @task.household = nil
    assert_not @task.valid?
  end

  test 'household should exist in database' do
    assert @task.valid?
    @task.household = Household.new()
    assert_not @task.valid?
  end
  
  test 'task assigned should now hold user' do
    @task.user = @u
    assert @task.valid?
  end
end
