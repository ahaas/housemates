# Kevin Sung and Opal Kale

require 'test_helper'

class UsersRegisterHouseholdTest < ActionDispatch::IntegrationTest
  def setup
     # User without a household
    @user1 = User.create(name: "jackie", email: "jackie@example.com",
                     password: "letmein", 
                     password_confirmation: "letmein")
    log_in_as @user1, password: 'letmein'
  end
   
  test "register household" do
    post households_create_path, household: {name: 'penguins'}
    assert_redirected_to home_path
    follow_redirect!
    assert_template 'households/show'
  end

  test "already in household" do
    post households_create_path, household: {name: 'penguins'}
    get households_new_path
    assert_not flash.empty? 
  end
  
  test "new household" do
    @user1.household = nil
    get households_new_path
    assert_template 'households/new'
  end

  test "invalid create household" do 
    post households_create_path, household: {name: nil}
    assert_template 'households/new'
  end

end
