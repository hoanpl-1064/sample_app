class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.active
      log_in user
      flash[:success] = t "account.create_success"
      redirect_to user
    else
      flash[:danger] = t "account.invalid_link"
      redirect_to root_url
    end
  end
end
