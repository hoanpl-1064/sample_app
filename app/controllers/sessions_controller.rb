class SessionsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
  end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate params[:session][:password]
      if user.activated?
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:danger] = t("account.not_activated")
        redirect_to root_path
      end
    else
      flash.now[:danger] = t "account.invalid_user"
      render :new
    end
  end

  def destroy
    log_out
  end
end
