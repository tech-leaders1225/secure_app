class SessionsController < ApplicationController

  def new
    easy_login
  end

  def create
    month = Date.today
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        params[:month] = Date.today.month
        if current_user.admin?
          redirect_to root_url
          flash[:success] = "ログインしました！（admin）"
        else
          redirect_to user_work_url(user,month)
          flash[:success] = "ログインしました！"
        end
      else
        message  = "アカウントが有効化されていません。 "
        message += "Prograから送られてきたメールのリンクをご確認ください！"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレスとパスワードが無効な組み合わせです。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:warning] = "ログアウトしました。"
    redirect_to root_url
  end
  
  
  private
  
  # ポートフォリオ用のログイン機能
    def easy_login
      month = Date.today
      params[:month] = Date.today.month
      if params[:user]
        if params[:user] == "ユーザー"
          user = User.find_by(email: "example-1@railstutorial.org")
          log_in user
          flash[:success] = "ログインしました！(一般ユーザー)"
          redirect_to user_work_url(user,month)
        elsif  params[:user] == "上長"
          user = User.find_by(email: "examplea@railstutorial.org")
          log_in user
          flash[:success] = "ログインしました！(上長ユーザー)"
          redirect_to user_work_url(user,month)
        else
          user = User.find_by(email: "admin@railstutorial.org")
          log_in user
          flash[:success] = "ログインしました！(管理ユーザー)"
          redirect_to root_url
        end
      end
    end
end