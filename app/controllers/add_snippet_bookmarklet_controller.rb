class AddSnippetBookmarkletController < ApplicationController

  def index
  end

  def create
    if signed_in?
      snippet = current_user.snippets.build(snippet_params)
      snippet.content = ActionView::Base::full_sanitizer.sanitize(snippet.content)
      if snippet.save
        snippet.create_activity :create, owner: current_user, parameters: { snippet_content: snippet.content }

        response = { status: "success", url: snippet_url(snippet) }
        render json: response.to_json, callback: params['callback']
      else
        response = { status: "fail", error: "That snippet couldn't be saved." }
        render json: response.to_json, callback: params['callback']
      end
    else
      response = { status: "no-user", error: "Please sign in first", url: signin_url }
      render json: response.to_json, callback: params['callback']
    end
  end

  def bookmarklet
  end

  private

    def snippet_params
      params.require(:snippet).permit(:content, :source)
    end
end
