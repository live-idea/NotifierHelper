require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    u = users(:one)
    assert_equal 2, u.contacts.size, 'checking users count'
  end
end
