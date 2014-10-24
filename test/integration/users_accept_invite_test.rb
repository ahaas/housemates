# Kevin Sung

require 'test_helper'

class UsersAcceptInviteTest < ActionDispatch::IntegrationTest
  def setup
    # Create a user with a household
    @user1 = User.create(name: "jackie", email: "jackie@example.com",
                     password: "letmein", 
                     password_confirmation: "letmein")
    @household1 = Household.create(name: 'stars')
    @user1.household = @household1
    @user1.save
    # Create another user with a household
    @user2 = User.create(name: "jenny", email: "jenny@example.com",
                     password: "letmein", 
                     password_confirmation: "letmein")
    @household2 = Household.create(name: 'coolkids')
    @user2.household = @household2
    @user2.save
    # Add invitations to both households
    Invite.create(household: @household1, email:'james@example.com')
    Invite.create(household: @household1, email: 'jacob@example.com')
    Invite.create(household: @household2, email: 'jacob@example.com')
    # Create invited emails' users
    @invited1 = User.create(name: "james", email: "james@example.com", password: "password", password_confirmation: "password")
    @invited2 = User.create(name: "jacob", email: "jacob@example.com", password: "password", password_confirmation: "password")                  
  end
  
  test "user has invite" do
    log_in_as @invited1, password: "password"
    assert_redirected_to invites_path
    post invites_accept_path, household: {@household1.id => 1}
    assert_redirected_to home_path
  end
  
  test "user has multiple invites" do
    log_in_as @invited2, password: "password"
    assert_redirected_to invites_path
    post invites_accept_path, household: {@household1.id => 2}
    assert_redirected_to home_path
  end
  
end
