class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      # @user = User.find(params[:id])
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
  
end
