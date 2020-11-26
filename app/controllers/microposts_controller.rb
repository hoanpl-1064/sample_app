class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach micropost_params[:image]

    if @micropost.save
      flash[:success] = t "post.micropost_created"
      redirect_to root_url
    else
      flash.now[:danger] = t "post.micropost_created_fail"
      @feed_items = current_user.feed.page(params[:page],
                                           per_page: Settings.page.per_page)
      render home_path
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = "post.deleted"
    else
      flash[:danger] = "fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "post.access_error"
    redirect_to root_url
  end
end
