require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  def setup
    @user = users(:shyam)
    @other_user = users(:prashant)
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    # get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url # page number 774
  end

  test "should redirect update when not logged in" do
    # patch users_path(@user), user: {name: @user.name, email: @user.email, password: '123456', password_confirmation: '123456' }
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: { name: @other_user.name, email: @other_user.email, admin: true }
    assert_not @other_user.admin?
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url # page number 779
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    # patch user_path(@user), user: { name: @user.name, email: @user.email, password: '123456', password_confirmation: '123456' }
    patch :update, id: @user, user: {name: @user.name, email: @user.email}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get :following, id: @user
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get :followers, id: @user
    assert_redirected_to login_url
  end
end
