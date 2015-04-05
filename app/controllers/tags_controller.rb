class TagsController < ApplicationController

  def show
    @reading_list_items = Rewrite.tagged_with(params[:tag]).paginate(page: params[:page])
    render 'shared/reading_list'
  end
end
