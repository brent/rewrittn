class AddSnippetBookmarkletController < ApplicationController

  def index
  end

  def create
    @snippet = current_user.snippets.build(add_snippet_bookmarklet_params)
    if @snippet.save
      render json: { status: "success" }
    else
      render json: { status: "error" }
    end
  end

  def bookmarklet
  end

  private

    def add_snippet_bookmarklet_params
      params.permit(:content, :source)
    end
end
