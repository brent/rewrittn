class RewritesController < ApplicationController

  def index
    @rewrites = Rewrite.paginate(page: params[:page])
  end

  def show
    @rewrite = Rewrite.find_by(id: params[:id])
  end

  def new
    @snippet = Snippet.find_by(id: params[:snippet])
    @rewrite = Rewrite.new
  end

  def create
    @rewrite = current_user.rewrites.build(rewrite_params)

    if @rewrite.save
      @rewrite.create_activity :create, owner: current_user, parameters: { rewrite_title: @rewrite.title, snippet_content: @rewrite.snippet.content }
      redirect_to @rewrite
    else
      flash[:error] = "Your rewrite couldn't be created. Try again?"
      @snippet = Snippet.find_by(id: @rewrite.snippet.id)
      render 'new'
    end
  end

  private

    def rewrite_params
      params.require(:rewrite).permit(:title, :content_before_snippet,
                                      :content_after_snippet, :snippet_id)
    end
end
