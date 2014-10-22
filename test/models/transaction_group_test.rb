# Tom Lai

require 'test_helper'

class TransactionGroupTest < ActiveSupport::TestCase
def setup
    @group = TransactionGroup.new(name:"test transaction", total_amount: 10.00)
  end

  test "should be valid" do
    assert @group.valid?
  end

  test "name should be present" do
  @group.name = nil
  assert_not @group.valid?
  end

  test "empty name should not be valid" do
  @group.name = ""
  assert_not @group.valid?
  end

  test "total_amount should be present" do
  @group.total_amount = nil
  assert_not @group.valid?
  end

  test "negative total_amount should not be valid" do
  @group.total_amount = -1.0
  assert_not @group.valid?
  end

  test "zero total_amount should not be valid" do
  @group.total_amount = 0.0
  assert_not @group.valid?
  end

  test "total_amount should round off after save" do
  @group.total_amount = 1.5454
  @group.save
  @group.reload
  assert @group.total_amount = 1.55

  @group.total_amount = 1.5444
  @group.save
  @group.reload
  assert @group.total_amount = 1.54
  end
end
