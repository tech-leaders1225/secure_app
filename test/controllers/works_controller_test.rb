require 'test_helper'

class WorksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
    @sv = users(:superviser)
    @time = Time.current
    
  end
  
  test "should redirect show when not logged in" do
    get user_work_path(@user, @time)
    assert_redirected_to login_url
  end
  
  test "should redirect work_update when not logged in as wrong user" do
    log_in_as(@other_user)
    patch user_work_path(@user, @time), params: { work: { day: "2018-05-31",
                                                          start_time: "2018-05-31 07:10:56",
                                                          end_time: "2018-05-31 07:10:56",
                                                          user_id: @user.id } }
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect work_create when not logged in as wrong user" do
    log_in_as(@other_user)
    post user_works_path(@user, @time), params: { work: { day: "2018-05-31",
                                                          start_time: "2018-05-31 07:10:56",
                                                          end_time: "2018-05-31 07:10:56",
                                                          user_id: @user.id } }
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect work_edit when not logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_work_path(@user, @time)
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect work_log when not logged in as wrong user" do
    log_in_as(@other_user)
    get work_log_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  # 違うユーザーで残業申請をするとフラッシュが出てrootへリダレクト
  # test 'should redirect create_overwork when logged in wrong user' do
  #   log_in_as(@other_user)
  #   patch create_overwork_user_work_path(@user, @time)
  #   assert_not flash.empty?
  #   assert_redirected_to root_url
  # end
  
    # 残業申請をすると勤怠が更新されて、showにリダイレクト
    # test "should sccess create_overwork" do
    #   log_in_as(@user)
    #   patch create_overwork_user_work_path(@user, "2018-12-2"), params: { work: { endtime_plan: "22:22",
    #                                                                         check_box: "false",
    #                                                                         work_content: "報告書作成",
    #                                                                         over_check: "上長A",
    #                                                                         day: "2018-12-2" } }
    #   assert_redirected_to user_work_url
    # end
  
#残業申請を許可すると、勤怠が更新されてwork/showにリダイレクト
# test "should get new" do
#   get new_user_path
#   assert_response :success
# end

# １ヶ月勤怠申請を送信すると、その月の最初の勤怠が更新され、works/showにリダレクト
# test "should redirect edit when not logged in" do
#   get edit_user_path(@user)
#   assert_not flash.empty?
#   assert_redirected_to login_url
# end

# １ヶ月勤怠を承認すると、その月の最初の勤怠が更新され、works/showにリダレクト
# test "should redirect update when not logged in" do
#     patch user_path(@user), params: { user: { name: @user.name,
#                                               email: @user.email } }
#     assert_not flash.empty?
#     assert_redirected_to login_url
# end

# 勤怠変更を申請すると、works/showにリダレクト 
# test "should redirect edit when logged in as wrong user" do
#     log_in_as(@user)
#     get edit_user_path(@other_user)
#     assert_not flash.empty?
#     assert_redirected_to root_url
# end

# 勤怠変更申請を承認すると、works/showにリダレクト 
# test "should redirect update when logged in as wrong user" do
#     log_in_as(@other_user)
#     patch user_path(@user), params: { user: { name: @user.name,
#                                               email: @user.email } }
#     assert_not flash.empty?
#     assert_redirected_to root_url
# end


# test "should not allow the admin attribute to be edited via the web" do
#     log_in_as(@other_user)
#     assert_not @other_user.admin?
#     patch user_path(@other_user), params: { user: { password: @other_user.password,
#                                                     password_confirmation: @other_user.password,
#                                                     admin: true
#                                                     } }
#   end
      

# test "should redirect destory when not logged in" do
#     assert_no_difference 'User.count' do
#         delete user_path(@user)
#     end
#     assert_redirected_to login_url
# end

# test "should redirect destory when logged in as a non-admin" do
#     log_in_as(@other_user)
#     assert_no_difference "User.count" do
#         delete user_path(@user)
#     end
#     assert_redirected_to root_url
# end

  
end
