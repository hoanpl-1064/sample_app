class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "account.email_reset_passwd"
      redirect_to root_url
    else
      flash.now[:danger] = t "account.email_not_found"
      render :new
    end
  end

  def update
    if user_params[:password].blank?
      @user.errors.add(:password, t("can_not_be_empty"))
      render :edit
    elsif @user.update(user_params)
      log_in @user
      @user.update_column :reset_digest, nil

      flash[:success] = t "account.update_success"
      redirect_to @user
    else
      flash.now[:danger] = t "fail"

      render :edit
    end
  end

  def edit; end

  private

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:warning] = t "account.account_nil"
    redirect_to signup_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
