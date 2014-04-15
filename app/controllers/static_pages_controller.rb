class StaticPagesController < ApplicationController
  def home
    if signed_in?
      # snippets = current_user.snippets_feed.paginate(page: params[:page])
      # rewrites = current_user.rewrites_feed.paginate(page: params[:page])
      # @feed_items = (snippets + rewrites).sort_by(&:created_at).paginate(page:params[:page])
      @feed_items = current_user.snippets_feed.paginate(page: params[:page])
    end
  end

  def about
  end

  def contact
  end
end
