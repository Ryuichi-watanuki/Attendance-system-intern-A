class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "アカウントの有効化ができました、早速はじめましょう！"
      redirect_to user
    else
      flash[:danger] = "既に有効化済みです。"
      redirect_to root_url
    end
  end
end