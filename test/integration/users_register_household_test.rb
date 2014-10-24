# Kevin Sung

require 'test_helper'

class UsersRegisterHouseholdTest < ActionDispatch::IntegrationTest
  def setup
     # User without a household
    @user1 = User.create(name: "jackie", email: "jackie@example.com",
                     password: "letmein", 
                     password_confirmation: "letmein")
  end
   
  test "register household" do
    log_in_as @user1, password: 'letmein'
    post households_create_path, household: {name: 'penguins'}
    assert_redirected_to home_path
    follow_redirect!
    assert_template 'households/show'
  end
end
