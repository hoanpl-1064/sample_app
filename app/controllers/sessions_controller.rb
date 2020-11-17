class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to root_path
    end
  end
  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate params[:session][:password]
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_to @user
    else
      flash.now[:danger] = t "account.invalid_user"
      render :new
    end
  end

  def destroy
    log_out
  end
end
