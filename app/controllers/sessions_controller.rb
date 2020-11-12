class SessionsController < ApplicationController
  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      # This method came from helper, call module from app_controller
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t "account.invalid_user"
      render :new
    end
  end

  def destroy
    log_out
  end
end
