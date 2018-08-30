require "date"
class UsersController < ApplicationController
  include UsersHelper
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
    @week = %w{日 月 火 水 木 金 土}
    
    if not params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      @first_day = Date.today.beginning_of_month
    end
    @last_day = @first_day.end_of_month
    
    # 取得月の初日から終日まで繰り返し処理
    (@first_day..@last_day).each do |day|
      # attendancesテーブルに各日付のデータがあるか
      if not @user.attendances.any? { |obj| obj.attendance_day == day }
        # ない日付はインスタンスを生成して保存する
        date = Attendance.new(user_id: @user.id, attendance_day: day)
        date.save
      end
    end
    
    # 当月を昇順で取得し@daysへ代入
    @days = @user.attendances.where('attendance_day >= ? and attendance_day <= ?', \
    @first_day, @last_day).order('attendance_day ASC')
    
    # 在社時間の集計、ついでに出勤日数も
    i = 0
    @days.each do |d|
      if d.time_in.present? && d.time_out.present?
        second = 0
        second = times(d.time_in,d.time_out)
        @total_time = @total_time.to_i + second.to_i
        i = i + 1
      end
    end
    @attendances_count = i
    
  
    
  end
  
  def time_in
    @user = User.find(params[:id])
    @time_in = @user.attendances.find_by(attendance_day: Date.current)
    @time_in.update_attributes(time_in: DateTime.current)
    flash[:info] = "今日も一日がんばるぞい！"
    redirect_to @user
  end

  def time_out
    @user = User.find(params[:id])
    @time_out = @user.attendances.find_by(attendance_day: Date.current)
    @time_out.update_attributes(time_out: DateTime.current)
    redirect_to @user
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

