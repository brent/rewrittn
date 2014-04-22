class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @feed_items = PublicActivity::Activity.order("created_at desc").paginate(page: params[:page])
    end
  end

  def about
  end

  def contact
  end
end
