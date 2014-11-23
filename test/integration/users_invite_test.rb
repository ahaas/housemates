# Kevin Sung, David Tien, Andre Haas

require 'test_helper'

class UsersInviteTest < ActionDispatch::IntegrationTest
  def setup
     # User without a household
    @user1 = User.create(name: "jackie", email: "jackie@example.com",
                     password: "letmein", 
                     password_confirmation: "letmein")
    @household1 = Household.create(name: 'stars')
    @user1.household = @household1
    @user1.save
  end
   
  test "single invite" do
    log_in_as @user1, password: 'letmein'

    message = stub(deliver: lambda {})
    message.expects(:deliver)
    InviteMailer.stubs(invite_email: message)

    post invites_create_path, invite: {email: 'jane@gmail.com', household: @user1.household}
    assert_redirected_to home_path
    follow_redirect!
    assert_not flash[:success].empty?
  end
  
  test "two invite" do
    log_in_as @user1, password: 'letmein'
    post invites_create_path, invite: {email: 'jane@example.com', household: @user1.household}
    assert_redirected_to home_path
    follow_redirect!
    assert_not flash[:success].empty?
    post invites_create_path, invite: {email: 'joe@example.com', household: @user1.household}
    assert_redirected_to home_path
    follow_redirect!
    assert_not flash[:success].empty?
  end
  
  test "bad invite" do
    log_in_as @user1, password: 'letmein'
    assert_no_difference 'Invite.count' do 
      post invites_create_path, invite: {email: 'joe@invalid', household: @user1.household}
      assert_redirected_to home_path
    end
  end
  
  test "email invited is too long" do
    log_in_as @user1, password: 'letmein'
    @email = 'james' * 55 + '@toolong.com' 
    assert_no_difference 'Invite.count' do 
      post invites_create_path, invite: {email: @email, household: @user1.household}
      assert_redirected_to home_path
    end
  end
    
end
