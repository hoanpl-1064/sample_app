class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :get_relationship, only: :destroy

  def create
    @user = User.find_by id: params[:followed_id]

    if @user
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t "fail"
      redirect_to home_path
    end
  end

  def destroy
    @user = @relationship.followed

    if @user
      current_user.unfollow(@user)
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t "fail"
      redirect_to home_path
    end
  end

  private

  def get_relationship
    return if @relationship = Relationship.find_by id: params[:id]

    flash[:danger] = t "fail"
    redirect_to home_path
  end
end
