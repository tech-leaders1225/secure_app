require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  
  test "should not save work without user_id" do
    work = Work.new
    assert_not work.save
  end
end
