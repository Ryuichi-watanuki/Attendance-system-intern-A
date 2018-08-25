class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                            :following, :followers]
  
  
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      @q = User.ransack(search_params, activated_true: true)
      @title = "Search Result"
    else
      @q = User.ransack(activated_true: true)
      @title = "All users"
    end
    @users = @q.result.paginate(page: params[:page])
  end
  
  # 勤怠表示画面
  def show
    @user = User.find(params[:id])
    @attendance = @user.attendances.find_by(params[:user_id])
    # @user_attendances = @user.attendances
    @attendance_day = @user.attendances.build(attendance_day: Date.today)
    
    @today = Date.today
    @first_day = @today.beginning_of_month
    @last_day = @today.end_of_month
  end
  
  def time_in
    @user = User.find(params[:id])
    @time_in = @user.attendances.build(attendance_day: Date.today, time_in: DateTime.now)
    @time_in.save
    
    
  end

  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "ご登録のアドレスにメールを送信しました。アカウントの有効化をお願いします"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following
    @title = "フォロー中"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def edit_basic_info
  end
  
  def time_display
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
      :affiliation, :basic_time, :specified_working_time, :password_confirmation)
    end
    
    def attendance_params
    end
    
    
    def search_params
      params.require(:q).permit(:name_cont)
    end
    
    # beforeアクション

    # ログイン済みユーザーかどうか確認
    # def logged_in_user
    #   unless logged_in?
    #   store_location
    #     flash[:danger] = "Please log in."
    #     redirect_to login_url
    #   end
    # end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end

