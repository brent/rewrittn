class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @feed_items = PublicActivity::Activity.order("created_at desc").paginate(page: params[:page])
    else
      redirect_to signup_path
    end
  end

  def about
  end

  def contact
  end
end
