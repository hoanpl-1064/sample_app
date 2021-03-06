class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.sort_name.paginate(page: params[:page],
                                     per_page: Settings.page.per_page)
  end

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page],
                                            per_page: Settings.page.per_page)
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "account.check_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "account.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "account.usr_deleted"
    else
      flash[:danger] = t "fail"
    end
    redirect_to users_url
  end

  def following
    @title = t "post.following"
    @users = @user.following.paginate page: params[:page]
    render :show_follow
  end

  def followers
    @title = t "post.follower"
    @users = @user.followers.paginate page: params[:page]
    render :show_follow
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "account.account_nil"
    redirect_to signup_path
  end

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    redirect_to edit_user_path(current_user) unless current_user? @user
  end

  def admin_user
    redirect_to(@user) unless current_user?(@user)
  end
end
