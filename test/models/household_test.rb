require 'test_helper'

class HouseholdTest < ActiveSupport::TestCase
  test "Household name must be present" do
    assert_not Household.new(name: '').save
  end
end
